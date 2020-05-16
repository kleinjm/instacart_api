# frozen_string_literal: true

# run this file with `ruby -I lib example_usage.rb`
require "instacart_api"

client = InstacartApi::Client.new(
  email: ENV.fetch("INSTA_EMAIL"),
  password: ENV.fetch("INSTA_PASSWORD"),
  default_store: "fairway-market"
).login

# stores = client.available_stores

# bananas = client.search(term: "banana")
# => Array of searh result Items

# sorting will compare items by price
# client.add_item_to_cart(item_id: bananas.sort.first.id, quantity: 1)
