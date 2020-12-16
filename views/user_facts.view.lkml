view: user_facts {
  derived_table: {
    explore_source: order_items {
      column: id { field: users.id }
      column: user_created { field: users.created_date }
      column: order_created { field: order_items.created_date }
      column: total_orders {}
    }
  }
  dimension: id {
    # primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }
  # measure: total_total_orders {
  #   type: sum
  #   sql: ${total_orders} ;;
  #   sql_distinct_key: ${id} ;;
  # }

  ################################################

  dimension: user_created {
    type: date
    sql: ${TABLE}.user_created ;;
  }
  dimension: order_created {
    type: date
    sql: ${TABLE}.order_created ;;
  }
  dimension: days_since_registered {
    type: number
    sql: datediff(day, ${TABLE}.user_created, ${TABLE}.order_created) ;;
  }
  dimension: new_old_user {
    type: string
    case: {
      when: {
        sql: ${days_since_registered} <= 90 ;;
        label: "New"
      }
      else: "Old"
    }
  }
}
