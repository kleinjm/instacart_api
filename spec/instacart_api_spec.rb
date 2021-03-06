# frozen_string_literal: true

RSpec.describe InstacartApi do
  it "has a version number" do
    expect(InstacartApi::VERSION).not_to be nil
  end

  describe "#login" do
    it "performs the login request and returns an instance of self" do
      stub_login

      client = described_class::Client.
        new(email: "test@gmail.com", password: "testing1")

      expect(client.login).to be_an_instance_of(InstacartApi::Client)
      expect(WebMock).to have_requested(:post, "https://www.instacart.com/accounts/login")
    end
  end

  describe "#get" do
    it "can GET request the give URL" do
      stub_login
      stub_search

      client = described_class::Client.
        new(email: "test@gmail.com", password: "testing1").login

      response = client.get(url: "v3/containers/fairway/search_v3/grapes?per=40&page=1")

      expect(response.code).to eq("200")
    end

    it "handles failed responses" do
      stub_login
      stub_search_failure

      client = described_class::Client.
        new(email: "test@gmail.com", password: "testing1").login

      expect do
        client.get(url: "v3/containers/fairway/search_v3/grapes?per=40&page=1")
      end.to raise_error(InstacartApi::Client::ResponseError)
    end
  end

  describe "#put" do
    it "can PUT request the give URL" do
      stub_login
      stub_add_item

      client = described_class::Client.
        new(email: "test@gmail.com", password: "testing1").login

      response = client.put(url: "v3/carts/123/update_items", payload: { "items" => [] })

      expect(response.code).to eq("200")
    end
  end

  def stub_add_item
    stub_request(:put, "https://www.instacart.com/v3/carts/123/update_items").
      to_return(status: 200, body: "", headers: {})
  end

  def stub_search_failure
    stub_request(:get, "https://www.instacart.com/v3/containers/fairway/search_v3/grapes?page=1&per=40").
      to_return(status: 500, body: "", headers: {})
  end
end
