connection: "snowlooker"
include: "/views/*.view"

explore: order_items {
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: one_to_many
  }
  join: order_facts {
    type: left_outer
    sql_on: ${order_items.id} = ${order_facts.id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_facts {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_facts.id} ;;
    relationship: many_to_one
  }
}

explore: customer {
  from: order_items
  join: users {
    type: left_outer
    sql_on: ${customer.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: order_facts {
    type: left_outer
    sql_on: ${customer.id} = ${order_facts.id} ;;
    relationship: many_to_one
  }
  join: customer_facts {
    type: left_outer
    sql_on: ${customer.id} = ${customer_facts.id} ;;
    relationship: many_to_one
  }
}
