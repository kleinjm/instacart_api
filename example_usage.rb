# frozen_string_literal: true

require "instacart_api"

client = InstacartApi::Client.new(
  email: ENV.fetch("INSTA_EMAIL"),
  password: ENV.fetch("INSTA_PASSWORD"),
  default_store: "fairway-market"
)

bananas = client.search(term: "banana")

client.add_item_to_cart(item_id: bananas.first.id, quantity: 1)
