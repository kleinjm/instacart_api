# frozen_string_literal: true

RSpec.describe Item do
  subject(:item) do
    described_class.new(
      "pricing" => { "price" => "$2.50" },
      "attributes" => %w[available previously_purchased]
    )
  end

  describe "#price" do
    it "parses the dollar-formatted price into a float" do
      expect(item.price).to eq(2.5)
    end
  end

  describe "#available?" do
    it "is true when the attributes include 'available'" do
      expect(item.available?).to be(true)
    end

    it "is false when the attributes omit 'available'" do
      expect(described_class.new("attributes" => []).available?).to be(false)
    end
  end

  describe "#buy_again?" do
    it "is true when previously purchased" do
      expect(item.buy_again?).to be(true)
    end
  end

  describe "#<=>" do
    it "compares items by price" do
      cheaper = described_class.new("pricing" => { "price" => "$1.00" })
      expect([item, cheaper].sort).to eq([cheaper, item])
    end
  end
end
