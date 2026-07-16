# frozen_string_literal: true

RSpec.describe InstacartApi::GraphqlClient do
  subject(:client) do
    described_class.new(session_cookie: "__Host-instacart_sid=abc")
  end

  let(:url) { "https://www.instacart.com/graphql" }

  describe "#query" do
    it "sends a persisted GET with auth headers and returns data" do
      stub_request(:get, url).
        with(query: hash_including("operationName" => "Items")).
        to_return(status: 200, body: '{"data":{"items":[]}}')

      expect(client.query("Items", ids: [])).to eq("items" => [])

      expect(WebMock).to have_requested(:get, url).
        with(
          query: hash_including(
            "operationName" => "Items",
            "variables" => '{"ids":[]}'
          ),
          headers: {
            "X-Client-Identifier" => "web",
            "Cookie" => "__Host-instacart_sid=abc"
          }
        )
    end

    it "encodes the persisted-query hash in the extensions param" do
      stub_request(:get, url).
        with(query: hash_including({})).
        to_return(status: 200, body: '{"data":{}}')

      client.query("Items", {})

      expect(WebMock).to have_requested(:get, url).with(query: hash_including(
        "extensions" => /#{InstacartApi::PersistedQueries.hash_for('Items')}/
      ))
    end
  end

  describe "#mutate" do
    it "sends a persisted POST body and returns data" do
      stub_request(:post, url).
        to_return(status: 200, body: '{"data":{"ok":true}}')

      expect(client.mutate("UpdateCartItemsMutation", foo: "bar")).
        to eq("ok" => true)

      expect(WebMock).to have_requested(:post, url).with { |req|
        body = JSON.parse(req.body)
        body["operationName"] == "UpdateCartItemsMutation" &&
          body["variables"] == { "foo" => "bar" } &&
          body.dig("extensions", "persistedQuery", "sha256Hash") ==
            InstacartApi::PersistedQueries.hash_for("UpdateCartItemsMutation")
      }
    end
  end

  describe "error handling" do
    it "raises ResponseError on a non-200 response" do
      stub_request(:get, url).
        with(query: hash_including({})).
        to_return(status: 500, body: "boom")

      expect { client.query("Items", {}) }.
        to raise_error(InstacartApi::ResponseError, /HTTP 500/)
    end

    it "raises GraphqlError when the body carries errors" do
      stub_request(:get, url).
        with(query: hash_including({})).
        to_return(
          status: 200,
          body: '{"errors":[{"message":"Invalid Variables"}],"data":null}'
        )

      expect { client.query("Items", {}) }.
        to raise_error(InstacartApi::GraphqlError, "Invalid Variables")
    end
  end
end
