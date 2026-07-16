# frozen_string_literal: true

module InstacartApi
  # One retailer's slice of a cross-retailer search: which store it is and the
  # ids of the items that matched there. Fetch full item details by passing
  # `item_ids` (with `shop_id`) to `Client#items`.
  class SearchResult
    attr_reader :retailer_id, :shop_id, :item_ids

    def initialize(data)
      @retailer_id = data["retailerId"]
      @shop_id = data["shopId"]
      @item_ids = data["itemIds"] || []
    end
  end
end
