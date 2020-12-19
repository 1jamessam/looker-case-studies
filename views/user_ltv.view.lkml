view: user_ltv {
  derived_table: {
    explore_source: order_items {
      column: user_id { field: users.id }
      column: total_orders { field: order_items.order_count }
      column: total_gross_revenue { field: order_facts.total_gross_revenue }
      column: first_order_created { field: order_items.first_order_created }
      column: last_order_created { field: order_items.last_order_created }
      column: user_count { field: users.count }
    }
  }
  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }
  dimension: orders_bracket {
    type: tier
    tiers: [1,2,3,6,10]
    sql: ${TABLE}.total_orders ;;
    style: integer
  }
  measure: total_lifetime_orders {
    type: sum
    sql: ${TABLE}.total_orders ;;
  }
  measure: average_lifetime_orders {
    type: average
    sql: ${TABLE}.total_orders ;;
  }
  dimension: total_gross_revenue {
    type: number
    sql: ${TABLE}.total_gross_revenue ;;
    value_format_name: usd_0
  }
  dimension: revenue_bracket {
    type: tier
    tiers: [0,5,20,50,100,500,1000]
    sql: ${TABLE}.total_gross_revenue ;;
    style: integer
    value_format_name: usd
  }
  measure: total_lifetime_revenue {
    type: sum
    sql: ${TABLE}.total_gross_revenue ;;
    value_format_name: usd_0
  }
  measure: average_lifetime_revenue {
    type: average
    sql: ${TABLE}.total_gross_revenue ;;
    value_format_name: usd_0
  }
  dimension: first_order_created {
    type: date
    sql: ${TABLE}.first_order_created ;;
  }
  dimension: last_order_created {
    type: date
    sql: ${TABLE}.last_order_created ;;
  }
  dimension: days_since_last_order {
    type: number
    sql: datediff(day, ${last_order_created}, current_date()) ;;
  }
  measure: average_days_since_last_order {
    type: average
    sql: ${days_since_last_order} ;;
  }
  dimension: is_repeated_customer {
    type: yesno
    sql: ${TABLE}.total_orders > 1 ;;
  }
  measure: user_count {
    type: sum
    sql: ${TABLE}.user_count ;;
  }
  measure: count {
    type: count
    drill_fields: [user_id]
  }
}
