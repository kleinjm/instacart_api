# Instacart Api

Ruby interface to Instacart used for programmatic grocery delivery.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'instacart_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install instacart_api

## Usage

Check out [example_usage.rb](https://github.com/kleinjm/instacart_api/blob/master/example_usage.rb) or see full example below.

```rb
require_relative "lib/instacart_api/client.rb"

client = Client.new(
  email: "jsmith@gmail.com",
  password: "my_password",
  default_store: "fairway-market"
)

bananas = client.search(term: "banana")
# => Array of Items

client.add_item_to_cart(item_id: bananas.first.id, quantity: 1)
```

## Development

After checking out the repo, run `bundle` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kleinjm/instacart_api.
