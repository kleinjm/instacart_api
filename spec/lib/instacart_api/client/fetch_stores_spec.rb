# frozen_string_literal: true

RSpec.describe InstacartApi::Client::Stores do
  describe "#available_stores" do
    it "returns a list of available_stores" do
      stub_retailers
      client = instantiate_client

      stores = client.available_stores
      expect(stores.count).to be > 1
      expect(stores).to all( be_a(String) )
      stores.each do |store|
        expect(store.downcase).to eq(store)
        expect(store).to_not include(" ")
      end
    end
  end

  def stub_retailers
    body = File.read("spec/artifacts/successful_retailers_response_body.txt")

    stub_request(
      :get, "https://www.instacart.com/v3/containers/next_gen/retailers"
    ).to_return(status: 200, body: body, headers: {})
  end
end
