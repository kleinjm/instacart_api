# frozen_string_literal: true

RSpec.describe InstacartApi::Item do
  let(:data) do
    JSON.parse(
      File.read(
        File.join(__dir__, "..", "..", "..", "fixtures", "items.json")
      )
    ).dig("data", "items")
  end

  let(:sparkling_water) { described_class.new(data[0]) }
  let(:bananas) { described_class.new(data[1]) }

  it "parses the core product attributes" do
    expect(sparkling_water).to have_attributes(
      id: "items_3113-17422780",
      name: "Spindrift® Lemon Sparkling Water",
      size: "12 fl oz",
      product_id: "17422780",
      brand_name: "spindrift",
      quantity_type: "each"
    )
  end

  it "parses the price into a float and keeps the regular price string" do
    expect(sparkling_water.price).to eq(6.99)
    expect(sparkling_water.full_price).to eq("$8.99")
  end

  describe "#available?" do
    it "is true for an in-stock item" do
      expect(sparkling_water).to be_available
      expect(sparkling_water.stock_level).to eq("highlyInStock")
    end

    it "is false for an out-of-stock item" do
      expect(bananas).not_to be_available
    end
  end

  describe "#<=>" do
    it "orders items cheapest-first" do
      expect([sparkling_water, bananas].sort).to eq([bananas, sparkling_water])
    end
  end
end
