# frozen_string_literal: true

module InstacartApi
  # A single product returned by the `Items` query.
  #
  # Instacart item ids look like `items_<retailerLocationId>-<productId>`
  # (e.g. `items_3113-22373938`); that full id is what the cart mutation
  # expects.
  class Item
    include Comparable

    attr_reader :id, :name, :size, :product_id, :brand_name,
                :price, :full_price, :quantity_type, :stock_level

    def initialize(data)
      @id = data["id"]
      @name = data["name"]
      @size = data["size"]
      @product_id = data["productId"]
      @brand_name = data["brandName"]

      pricing = data.dig("price", "viewSection") || {}
      @price = pricing["priceValueString"]&.to_f
      @full_price = pricing["fullPriceString"]

      availability = data["availability"] || {}
      @available = availability["available"]
      @stock_level = availability["stockLevel"]

      @quantity_type =
        (data["quantityAttributes"] || {})["quantityType"] || "each"
    end

    def available?
      @available == true
    end

    # Compare by price so a list of items can be sorted cheapest-first.
    def <=>(other)
      price <=> other.price
    end
  end
end
