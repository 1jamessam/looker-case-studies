include: "/models/james_snowflake.model.lkml"
view: order_facts {
  derived_table: {
    explore_source: order_items{
      column: id {}
      column: status {}
      column: is_completed {}
      column: revenue {}
      column: cost { field: inventory_items.cost }
    }
  }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status;;
  }
  dimension: gross_margin {
    type: number
    sql: case when ${TABLE}.is_completed
      then ${TABLE}.revenue - ${TABLE}.cost
      else 0 end;;
  }
  measure: total_gross_revenue {
    type: sum
    sql: ${TABLE}.revenue ;;
  }
  measure: total_gross_margin {
    type: sum
    sql: ${gross_margin} ;;
  }
  measure: average_gross_margin {
    type: average
    sql: ${gross_margin} ;;
  }
  measure: gross_margin_percentage {
    type: number
    sql: ${total_gross_margin} / nullif(${total_gross_revenue},0) ;;
    value_format_name: percent_2
  }
  measure: gross_revenue_percentage {
    type: percent_of_total
    sql: ${total_gross_revenue} ;;
    # sql: ${TABLE}.revenue ;;
  }

}
