# frozen_string_literal: true

module InstacartApi
  # A shopping cart, as returned by the cart mutation/queries. Instacart keeps a
  # separate cart per retailer; `item_count` is the total line quantity.
  class Cart
    # A single line in the cart.
    class LineItem
      attr_reader :id, :item_id, :product_id, :quantity, :quantity_type

      def initialize(data)
        @id = data["id"]
        basket_product = data["basketProduct"] || {}
        @item_id = basket_product["id"]
        @product_id = basket_product["productId"]
        @quantity = data["quantity"]
        @quantity_type = data["quantityType"]
      end
    end

    attr_reader :id, :cart_type, :retailer_id, :item_count, :items

    def initialize(data)
      @id = data["id"]
      @cart_type = data["cartType"]
      @retailer_id = data["retailerId"]
      @item_count = data["itemCount"]

      line_items = data.dig("cartItemCollection", "cartItems") || []
      @items = line_items.map { |line_item| LineItem.new(line_item) }
    end
  end
end
