# frozen_string_literal: true

# Run this file with `ruby -I lib example_usage.rb`.
#
# Instacart's login is bot-protected and can't be scripted, so authentication
# is the session cookie from a real browser login. Grab it from your browser's
# devtools (the `__Host-instacart_sid` cookie and its companions) or with the
# capture script in `capture/`, and export it along with your delivery zone:
#
#   export INSTACART_COOKIE="__Host-instacart_sid=...; ..."
#   export INSTACART_POSTAL_CODE="97202"
#   export INSTACART_ZONE_ID="103"
require "instacart_api"

client = InstacartApi::Client.new(
  session_cookie: ENV.fetch("INSTACART_COOKIE"),
  postal_code: ENV.fetch("INSTACART_POSTAL_CODE"),
  zone_id: ENV.fetch("INSTACART_ZONE_ID")
)

# Search across the stores serving your location. `shop_ids` are the shops to
# search; you can get them from your store context (the search response also
# echoes the retailers that matched).
results = client.search(term: "bananas", shop_ids: %w[1292 580])
group = results.first
puts "#{group.item_ids.size} matches at shop #{group.shop_id}"

# Look up full details (name, price, availability) for those item ids.
items = client.items(ids: group.item_ids, shop_id: group.shop_id)
cheapest = items.select(&:available?).min # Item is Comparable by price
puts "Cheapest: #{cheapest.name} — $#{cheapest.price}"

# Add it to your cart (quantity: 0 would remove it). Returns the updated cart.
cart = client.add_item_to_cart(item_id: cheapest.id, quantity: 1)
puts "Cart #{cart.id} now has #{cart.item_count} item(s)"
