# frozen_string_literal: true

require_relative "../models/item"

class Client
  def search(term:, store: default_store)
    term_query = URI.encode(term)
    response = get(url: "v3/containers/#{store}/search_v3/#{term_query}?per=40")

    parse_search_response(response: response.body)
  end

  private

  def parse_search_response(response:)
    items_json(response: response).map do |item_json|
      Item.new(item_json)
    end
  end

  def items_json(response:)
    json_body = JSON.parse(response)
    json_body.dig("container", "modules").find do |mod|
      mod["id"] =~ /search_result_set_/
    end.dig("data", "items")
  end
end
