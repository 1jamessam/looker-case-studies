# include: "./inventory_items.view"
include: "/**/*"
view: order_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: order_items.id }
      column: status { field: order_items.status }
      column: sale_price { field: order_items.sale_price }
      column: cost { field: inventory_items.cost }
      column: user_id { field: order_items.user_id }
    }
  }
  dimension: order_id {
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
    sql: ${total_gross_margin} / ${total_gross_revenue} ;;
    value_format_name: percent_2
  }
  measure: total_gross_revenue {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [is_sold: "yes"]
    value_format_name: usd_0
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
}
