view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }
  dimension: age_bracket {
    type: tier
    tiers: [15, 26, 36, 51, 66]
    sql: ${age} ;;
    drill_fields: [gender]
    style: integer
  }
  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
  }
  # dimension: is_new_user {
  #   type: yesno
  #   sql: datediff(day, ${created_date}, current_date()) <= 90 ;;
  # }
  dimension: is_new_user {
    type: string
    case: {
      when: {
        sql: datediff(day, ${created_date}, current_date()) <= 90 ;;
        label: "New user"
      }
      else: "Old user"
    }
  }
  dimension: days_since_sign_up {
    type: number
    sql: datediff(day, ${created_date}, current_date()) ;;
  }
  dimension: days_since_sign_up_bracket {
    type: tier
    tiers: [1,100,200,300,400]
    sql: ${days_since_sign_up} ;;
    style: integer
  }
  dimension: months_since_sign_up {
    type: number
    sql: datediff(month, ${created_date}, current_date()) ;;
  }
  measure: average_days_since_sign_up {
    type: average
    sql: ${days_since_sign_up} ;;
  }
  measure: average_months_since_sign_up {
    type: average
    sql: ${months_since_sign_up} ;;
  }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_month
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }
  dimension: location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
    drill_fields: [products.category, products.brand]
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
    drill_fields: [age_bracket, gender]
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}
