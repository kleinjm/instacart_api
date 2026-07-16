# frozen_string_literal: true

module ApiSupport
  GRAPHQL_URL = "https://www.instacart.com/graphql"

  def fixture(name)
    File.read(File.join(__dir__, "..", "fixtures", "#{name}.json"))
  end

  # Stub a persisted GraphQL query (GET), matched by operation name.
  def stub_query(operation, fixture_name)
    stub_request(:get, GRAPHQL_URL).
      with(query: hash_including("operationName" => operation)).
      to_return(
        status: 200,
        body: fixture(fixture_name),
        headers: { "Content-Type" => "application/json" }
      )
  end

  # Stub a persisted GraphQL mutation (POST), matched by operation name.
  def stub_mutation(operation, fixture_name)
    stub_request(:post, GRAPHQL_URL).
      with(body: hash_including("operationName" => operation)).
      to_return(
        status: 200,
        body: fixture(fixture_name),
        headers: { "Content-Type" => "application/json" }
      )
  end

  def build_client(**overrides)
    defaults = {
      session_cookie: "__Host-instacart_sid=test-cookie",
      postal_code: "97202",
      zone_id: "103"
    }
    InstacartApi::Client.new(**defaults.merge(overrides))
  end
end

RSpec.configure do |config|
  config.include ApiSupport
end
