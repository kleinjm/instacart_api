# frozen_string_literal: true

RSpec.describe InstacartApi::Client::ItemSearch do
  describe "#search" do
    it "performs the search request" do
      stub_login
      stub_search(term: "grapes")

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1", default_store: "fairway").login

      items = client.search(term: "grapes")

      expect(items.count).to eq(0)
    end
  end
end
