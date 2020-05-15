# frozen_string_literal: true

RSpec.describe InstacartApi::AddItemToCart do
  describe "#add_item_to_cart" do
    it "performs the PUT request" do
      stub_login
      stub_add_item

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1", default_store: nil)

      response = client.add_item_to_cart(item_id: 123, quantity: 1)

      expect(response.code).to eq("200")
    end
  end

  describe "#add_items_to_cart" do
    it "performs the PUT request" do
      stub_login
      stub_add_item

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1", default_store: nil)

      response = client.add_items_to_cart(items: [{ item_id: 123, quantity: 1 }])

      expect(response.code).to eq("200")
    end
  end

  def stub_login
    body = File.read("spec/artifacts/successful_login_response_body.txt")
    cookie = File.read("spec/artifacts/successful_login_response_cookie.txt").strip

    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: body, headers: { "set-cookie" => cookie })
  end

  def stub_add_item
    stub_request(:put, "https://www.instacart.com/v3/carts/56789/update_items").
      to_return(status: 200, body: "", headers: {})
  end
end
