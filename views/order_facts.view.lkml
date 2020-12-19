# include: "./inventory_items.view"
include: "/**/*"
view: order_facts {
  # sql_table_name: order.order_facts ;;
  derived_table: {
    explore_source: order_items {
      column: id { field: order_items.id }
      column: status { field: order_items.status }
      column: sale_price { field: order_items.sale_price }
      column: cost { field: inventory_items.cost }
      column: user_id { field: order_items.user_id }
      column: created_time { field: order_items.created_time }
      derived_column: order_sequence {
        sql: RANK() OVER (PARTITION BY user_id ORDER BY created_time) ;;
      }
      derived_column: previous_order_date {
        sql: lag(created_time) over (partition by user_id order by created_time) ;;
      }
      derived_column: next_order_date {
        sql: lead(created_time) over (partition by user_id order by created_time) ;;
      }
    }
  }
  dimension: order_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: is_sold {
    type: yesno
    sql: ${TABLE}.status not in ('Returned', 'Cancelled') ;;
  }
  measure: gross_margin_percentage {
    type: number
    sql: ${total_gross_margin} / nullif(${total_gross_revenue},0) ;;
    value_format_name: percent_2
  }
  measure: total_gross_revenue {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [is_sold: "yes"]
    value_format_name: usd_0
  }
  measure: revenue_percentage_of_total {
    type: percent_of_total
    sql: ${total_gross_revenue} ;;
  }
  dimension: raw_margin {
    hidden: yes
    type: number
    sql: ${TABLE}.sale_price - ${TABLE}.cost ;;
  }
  measure: total_gross_margin {
    type: sum
    sql: ${raw_margin} ;;
    filters: [is_sold: "yes"]
    value_format_name: usd_0
    drill_fields: [products.category, products.brand]
  }
  measure: average_gross_margin {
    type: average
    sql: ${raw_margin} ;;
    filters: [is_sold: "yes"]
    value_format_name: usd_0
  }
  measure: unique_customers_item_return {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
    filters: [status: "Returned"]
  }
  measure: total_users {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }
  measure: customer_item_return_percentage {
    type: number
    sql: ${unique_customers_item_return} / ${total_users} ;;
    value_format_name: percent_2
  }
  measure: average_spend_per_customer {
    type: number
    sql: ${total_gross_revenue} / ${total_users} ;;
    value_format_name: usd_0
  }
  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }
  dimension: created_date {
    type: date
    sql: ${TABLE}.created_time ;;
  }
  dimension: previous_order_date {
    # hidden: yes
    type: date
    sql: ${TABLE}.previous_order_date ;;
  }
  dimension: days_since_last_order {
    type: number
    sql: datediff(day, ${TABLE}.previous_order_date, ${TABLE}.created_time) ;;
  }
  measure: average_days_between_orders {
    type: average
    sql: ${days_since_last_order} ;;
  }
  dimension: is_first_order {
    type: yesno
    case: {
      when: {
        sql: ${TABLE}.order_sequence = 1 ;;
        label: "First order"
      }
    }
    sql: ${TABLE}.order_sequence = 1 ;;
  }
  dimension: has_subsequent_order {
    type: yesno
    sql: ${TABLE}.next_order_date is not null ;;
  }
  dimension: is_less_than_60_days_since_last_purchase {
    type: yesno
    sql: ${days_since_last_order} < 60;;
  }
}
