# frozen_string_literal: true

module InstacartApi
  # High-level Instacart client: search for products, look up item details, and
  # add items to the logged-in user's cart.
  #
  #   client = InstacartApi::Client.new(
  #     session_cookie: ENV.fetch("INSTACART_COOKIE"),
  #     postal_code: "97202",
  #     zone_id: "103"
  #   )
  #
  # `postal_code` and `zone_id` come from the account's delivery address; they
  # scope search and pricing to the stores that serve that location.
  class Client
    def initialize(session_cookie:, postal_code:, zone_id:, shop_id: "0")
      @postal_code = postal_code
      @zone_id = zone_id
      @shop_id = shop_id
      @graphql = GraphqlClient.new(session_cookie: session_cookie)
    end

    # Search across the retailers serving this location. `shop_ids` is the list
    # of shop ids to search (from the account's store context). Returns one
    # SearchResult per retailer that had matches.
    def search(term:, shop_ids:, first: 7)
      data = graphql.query(
        "SearchCrossRetailerGroupResults",
        searchSource: "cross_retailer_search",
        query: term,
        shopIds: shop_ids,
        first: first,
        shopId: shop_id,
        zoneId: zone_id,
        postalCode: postal_code,
        disableAutocorrect: false,
        includeDebugInfo: false,
        overrideFeatureStates: [],
        autosuggestImpressionId: nil,
        pageViewId: nil
      )

      data.fetch("searchCrossRetailerGroupResults").
        fetch("results").
        map { |result| SearchResult.new(result) }
    end

    # Full item details for a set of item ids at one shop. Returns [Item].
    def items(ids:, shop_id:)
      data = graphql.query(
        "Items",
        ids: ids,
        shopId: shop_id,
        zoneId: zone_id,
        postalCode: postal_code
      )

      data.fetch("items").map { |item| Item.new(item) }
    end

    # Add (or update) a single item in the active cart. A `quantity` of 0
    # removes it. Returns the updated Cart.
    def add_item_to_cart(item_id:, quantity: 1, quantity_type: "each")
      add_items_to_cart(
        items: [
          { item_id: item_id, quantity: quantity, quantity_type: quantity_type }
        ]
      )
    end

    # Add (or update) several items in one mutation. Each entry is a hash with
    # :item_id, :quantity, and optional :quantity_type. Returns the updated
    # Cart.
    def add_items_to_cart(items:)
      updates = items.map do |item|
        {
          itemId: item.fetch(:item_id),
          quantity: item.fetch(:quantity),
          quantityType: item.fetch(:quantity_type, "each"),
          trackingParams: { trackingProperties: {} }
        }
      end

      data = graphql.mutate(
        "UpdateCartItemsMutation", cartItemUpdates: updates
      )

      Cart.new(data.fetch("updateCartItems").fetch("cart"))
    end

    # The logged-in user's active carts. Returns [Cart].
    def active_carts
      data = graphql.query("PersonalActiveCarts", {})

      data.fetch("userCarts").fetch("carts").map { |cart| Cart.new(cart) }
    end

    private

    attr_reader :graphql, :postal_code, :zone_id, :shop_id
  end
end
