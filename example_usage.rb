# frozen_string_literal: true

# run this file with `ruby -I lib example_usage.rb`
require "instacart_api"

# instantiate the client and log in
client = InstacartApi::Client.new(
  email: ENV.fetch("INSTA_EMAIL"),
  password: ENV.fetch("INSTA_PASSWORD")
).login

# fetch all available stores
stores = client.available_stores
# pick a store
client.default_store = stores.first

# search a term to find items
bananas = client.search(term: "banana")
# => Array of searh result Items

# add an item to your cart
# Note: sorting will compare items by price
# client.add_item_to_cart(item_id: bananas.sort.first.id, quantity: 1)
