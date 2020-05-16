# frozen_string_literal: true

module InstacartApi
  class Client
    module Stores
      def available_stores
        response = get(url: "v3/containers/next_gen/retailers")

        JSON.parse(response.body).dig("container", "modules").find do |mod|
          mod["id"] =~ /retailers_primary_selection_/
        end.dig("data", "retailers").map do |store|
          store["name"].tr(" ", "-").downcase
        end
      end
    end
  end
end
