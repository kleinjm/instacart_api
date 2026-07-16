# frozen_string_literal: true

RSpec.describe InstacartApi::Cart do
  let(:data) do
    JSON.parse(
      File.read(
        File.join(__dir__, "..", "..", "..", "fixtures",
                  "update_cart_items.json")
      )
    ).dig("data", "updateCartItems", "cart")
  end

  subject(:cart) { described_class.new(data) }

  it "parses cart-level attributes" do
    expect(cart).to have_attributes(
      id: "3693684252",
      cart_type: "grocery",
      retailer_id: "200",
      item_count: 1
    )
  end

  it "parses each line item" do
    line_item = cart.items.first

    expect(line_item).to have_attributes(
      id: "34540770075",
      item_id: "items_3113-22373938",
      product_id: "22373938",
      quantity: 1.0,
      quantity_type: "each"
    )
  end

  it "defaults to no line items when the collection is absent" do
    expect(described_class.new("id" => "empty").items).to eq([])
  end
end
