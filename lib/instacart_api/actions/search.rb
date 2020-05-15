# frozen_string_literal: true

require_relative "../models/item"

module InstacartApi
  class Client
    module Search
      def search(term:, store: default_store)
        @term_query = URI.encode(term)
        @store = store
        @items = []
        @page = 1

        data_json = fetch_items
        total_pages = data_json.dig("pagination", "total_pages")

        while @page < total_pages
          @page += 1
          fetch_items
        end

        @items
      end

      private

      def fetch_items
        response = get(
          url: "v3/containers/#{@store}/search_v3/#{@term_query}" \
               "?per=40&page=#{@page}"
        )

        data_json = data_json(response: response)
        data_json.fetch("items").map do |item_json|
          @items << Item.new(item_json)
        end

        data_json
      end

      def data_json(response:)
        json_body = JSON.parse(response.body)
        json_body.dig("container", "modules").find do |mod|
          mod["id"] =~ /search_result_set_/
        end.fetch("data")
      end
    end
  end
end
