# frozen_string_literal: true

RSpec.describe InstacartApi do
  it "has a version number" do
    expect(InstacartApi::VERSION).not_to be nil
  end

  it "can GET request the give URL" do
    stub_login
    stub_search

    client = described_class::Client.
      new(email: "test@gmail.com", password: "testing1", default_store: nil)

    response = client.get(url: "v3/containers/fairway/search_v3/grapes?per=40&page=0")

    expect(response.code).to eq("200")
  end

  it "can PUT request the give URL" do
    stub_login
    stub_add_item

    client = described_class::Client.
      new(email: "test@gmail.com", password: "testing1", default_store: nil)

    response = client.put(url: "v3/carts/123/update_items", payload: { "items" => [] })

    expect(response.code).to eq("200")
  end

  it "handles failed responses" do
    stub_login
    stub_search_failure

    client = described_class::Client.
      new(email: "test@gmail.com", password: "testing1", default_store: nil)

    expect do
      client.get(url: "v3/containers/fairway/search_v3/grapes?per=40&page=0")
    end.to raise_error(InstacartApi::Client::ResponseError)
  end

  def stub_login
    body = File.read("spec/artifacts/successful_login_response_body.txt")
    cookie = File.read("spec/artifacts/successful_login_response_cookie.txt").strip

    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: body, headers: { "set-cookie" => cookie })
  end

  def stub_search
    stub_request(:get, "https://www.instacart.com/v3/containers/fairway/search_v3/grapes?page=0&per=40").
      to_return(status: 200, body: "", headers: {})
  end

  def stub_add_item
    stub_request(:put, "https://www.instacart.com/v3/carts/123/update_items").
      to_return(status: 200, body: "", headers: {})
  end

  def stub_search_failure
    stub_request(:get, "https://www.instacart.com/v3/containers/fairway/search_v3/grapes?page=0&per=40").
      to_return(status: 500, body: "", headers: {})
  end
end
