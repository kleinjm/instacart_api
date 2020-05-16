# frozen_string_literal: true

module InstacartApi
  class Client
    module AddItemToCart
      def add_item_to_cart(item_id:, quantity:)
        put(
          url: "v3/carts/#{cart_id}/update_items",
          payload: {
            "items" => [{ "item_id" => item_id, "quantity" => quantity }]
          }
        )
      end

      def add_items_to_cart(items:)
        put(
          url: "v3/carts/#{cart_id}/update_items",
          payload: { "items" => items }
        )
      end
    end
  end
end
