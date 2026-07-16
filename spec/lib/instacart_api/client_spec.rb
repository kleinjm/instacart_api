# frozen_string_literal: true

RSpec.describe InstacartApi::Client do
  let(:client) { build_client }

  describe "#search" do
    it "returns a SearchResult per retailer group" do
      stub_query(
        "SearchCrossRetailerGroupResults",
        "search_cross_retailer_group_results"
      )

      results = client.search(term: "eggs", shop_ids: %w[1292 580])

      expect(results.map(&:retailer_id)).to eq(%w[200 7])
      expect(results.first.shop_id).to eq("1292")
      expect(results.first.item_ids).to include("items_3113-22373938")
    end

    it "sends the search term and location context" do
      stub_query(
        "SearchCrossRetailerGroupResults",
        "search_cross_retailer_group_results"
      )

      client.search(term: "eggs", shop_ids: ["1292"])

      expect(WebMock).to have_requested(:get, ApiSupport::GRAPHQL_URL).
        with(query: hash_including(
          "variables" => /"query":"eggs".*"postalCode":"97202"/
        ))
    end
  end

  describe "#items" do
    it "returns Item objects with parsed prices" do
      stub_query("Items", "items")

      items = client.items(ids: ["items_3113-17422780"], shop_id: "1292")

      expect(items.map(&:name)).to eq(
        ["Spindrift® Lemon Sparkling Water", "Organic Bananas"]
      )
      expect(items.first.price).to eq(6.99)
      expect(items.first).to be_available
    end
  end

  describe "#add_item_to_cart" do
    it "adds a single item and returns the updated cart" do
      stub_mutation("UpdateCartItemsMutation", "update_cart_items")

      cart = client.add_item_to_cart(item_id: "items_3113-22373938")

      expect(cart.item_count).to eq(1)
      expect(cart.items.first.item_id).to eq("items_3113-22373938")

      expect(WebMock).to have_requested(:post, ApiSupport::GRAPHQL_URL).
        with { |req|
          update = JSON.parse(req.body).dig("variables", "cartItemUpdates", 0)
          update == {
            "itemId" => "items_3113-22373938",
            "quantity" => 1,
            "quantityType" => "each",
            "trackingParams" => { "trackingProperties" => {} }
          }
        }
    end
  end

  describe "#add_items_to_cart" do
    it "adds several items in one mutation" do
      stub_mutation("UpdateCartItemsMutation", "update_cart_items")

      cart = client.add_items_to_cart(
        items: [
          { item_id: "items_3113-22373938", quantity: 2 },
          { item_id: "items_3113-17422780", quantity: 1, quantity_type: "each" }
        ]
      )

      expect(cart).to be_a(InstacartApi::Cart)

      expect(WebMock).to have_requested(:post, ApiSupport::GRAPHQL_URL).
        with { |req|
          updates = JSON.parse(req.body).dig("variables", "cartItemUpdates")
          updates.length == 2 &&
            updates.first["quantity"] == 2 &&
            updates.first["quantityType"] == "each"
        }
    end
  end

  describe "#active_carts" do
    it "returns the logged-in user's carts" do
      stub_query("PersonalActiveCarts", "personal_active_carts")

      carts = client.active_carts

      expect(carts.map(&:id)).to eq(["3693684252"])
      expect(carts.first.item_count).to eq(2)
    end
  end
end
