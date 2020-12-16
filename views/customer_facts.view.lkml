view: customer_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: total_orders { field: user_facts.total_orders }
    }
  }
  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }
  # dimension: total_items_sold {
  #   type: number
  #   sql: ${TABLE}.total_items_sold ;;
  # }
  # dimension: orders_group {
  #   type: tier
  #   tiers: [1,2,3,6,10]
  #   sql: ${TABLE}.total_items_sold ;;
  #   style: integer
  # }
}
