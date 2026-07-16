# Instacart Api

[![CI](https://github.com/kleinjm/instacart_api/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/kleinjm/instacart_api/actions/workflows/ci.yml)

Ruby wrapper around Instacart's (undocumented) web GraphQL API: search for
products across the stores serving an address, look up item details, and add
items to the logged-in user's cart.

> ⚠️ This talks to Instacart's private web API, not an official/supported
> product. Endpoints and persisted-query hashes change without notice, and
> automated access may be against Instacart's Terms of Service. Use it for
> personal automation at your own risk.

## Installation

```ruby
gem "instacart_api"
```

## Authentication

Instacart's login is bot-protected and can't be scripted, so the gem
authenticates with the **session cookie** from a real browser login rather than
an email/password. After logging in at instacart.com, copy the `Cookie` header
(at minimum the `__Host-instacart_sid` cookie and its companions) from your
browser devtools.

You also need your delivery `postal_code` and `zone_id` (both visible in the
GraphQL request variables on instacart.com), which scope search and pricing to
the stores serving that location.

## Usage

```ruby
require "instacart_api"

client = InstacartApi::Client.new(
  session_cookie: ENV.fetch("INSTACART_COOKIE"),
  postal_code: "97202",
  zone_id: "103"
)

# Search across the stores serving your location.
results = client.search(term: "bananas", shop_ids: %w[1292 580])
group = results.first

# Fetch full details (name, price, availability) for the matched item ids.
items = client.items(ids: group.item_ids, shop_id: group.shop_id)
cheapest = items.select(&:available?).min   # Item is Comparable by price

# Add it to the cart (quantity: 0 removes it). Returns the updated cart.
cart = client.add_item_to_cart(item_id: cheapest.id, quantity: 1)
cart.item_count # => 1

# Or add several at once, and inspect the active carts.
client.add_items_to_cart(items: [
  { item_id: cheapest.id, quantity: 2 }
])
client.active_carts
```

See [example_usage.rb](example_usage.rb) for a runnable version.

## Keeping it working

The gem pins the persisted-query hashes Instacart's web client uses. When
Instacart ships a new frontend build these rotate and calls start raising
`GraphqlError`/`UnknownOperationError`. Recapture them with the tool in
[`capture/`](capture/README.md) and update
`lib/instacart_api/persisted_queries.rb`.

## Development

```bash
bundle install
bundle exec rspec    # test suite (100% line coverage enforced)
bundle exec rubocop  # lint
```

## Releasing

Releases publish to RubyGems via GitHub Actions using
[trusted publishing](https://guides.rubygems.org/trusted-publishing/) (OIDC — no
API key stored). One-time setup: on rubygems.org, add this repository and the
`Release` workflow as a trusted publisher for the gem.

Then bump `InstacartApi::VERSION`, commit, and push a matching tag:

```bash
git tag v0.2.0
git push origin v0.2.0
```

The `Release` workflow runs the tests and publishes the gem.

## Contributing

Bug reports and pull requests are welcome at
https://github.com/kleinjm/instacart_api.
