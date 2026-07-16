# frozen_string_literal: true

RSpec.describe InstacartApi::Client::ItemSearch do
  describe "#search" do
    it "performs the search request" do
      stub_login
      stub_search(term: "grapes")

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1").login
      client.default_store = "fairway"

      items = client.search(term: "grapes")

      expect(items.count).to eq(0)
    end

    it "walks every page and builds an Item per result" do
      stub_login
      stub_search_page(term: "grapes", page: 1, total_pages: 2, item_name: "red")
      stub_search_page(term: "grapes", page: 2, total_pages: 2, item_name: "green")

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1").login
      client.default_store = "fairway"

      items = client.search(term: "grapes")

      expect(items.map(&:name)).to eq(%w[red green])
      expect(items).to all(be_a(Item))
    end

    def stub_search_page(term:, page:, total_pages:, item_name:)
      body = {
        container: {
          modules: [
            {
              id: "search_result_set_",
              data: {
                items: [{ name: item_name }],
                pagination: { total_pages: total_pages }
              }
            }
          ]
        }
      }.to_json

      stub_request(
        :get,
        "https://www.instacart.com/v3/containers/fairway/" \
          "search_v3/#{term}?page=#{page}&per=40"
      ).to_return(status: 200, body: body, headers: {})
    end
  end
end
