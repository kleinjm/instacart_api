# frozen_string_literal: true

module InstacartApi
  class Client
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

    private

    def cart_id
      @cart_id ||=
        JSON.parse(login_response.body).dig("data", "bootstrap_cart", "id")
    end
  end
end
