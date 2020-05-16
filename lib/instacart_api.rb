# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

require "instacart_api/client/add_item_to_cart"
require "instacart_api/client/item_search"
require "instacart_api/client/login"
require "instacart_api/client/response_error"
require "instacart_api/client/stores"
require "instacart_api/version"

module InstacartApi
  class Client
    include AddItemToCart
    include ItemSearch
    include Login
    include Stores

    attr_accessor :default_store

    BASE_DOMAIN = "https://www.instacart.com"
    REQ_OPTIONS = { use_ssl: true }.freeze

    def initialize(email:, password:)
      @email = email
      @password = password
    end

    def get(url:)
      uri = URI.parse("#{BASE_DOMAIN}/#{url}")

      request = Net::HTTP::Get.new(uri)

      perform_request(uri: uri, request: request)
    end

    def put(url:, payload:)
      uri = URI.parse("#{BASE_DOMAIN}/#{url}")

      request = Net::HTTP::Put.new(uri)
      request.body = JSON.dump(payload)

      perform_request(uri: uri, request: request)
    end

    private

    attr_reader(
      :cart_id,
      :email,
      :password,
      :session_cookie
    )

    def perform_request(uri:, request:)
      configure_request(request: request)
      response = Net::HTTP.start(uri.hostname, uri.port, REQ_OPTIONS) do |http|
        http.request(request)
      end

      raise ResponseError unless response.code.match?("200")

      response
    end

    def configure_request(request:)
      request.content_type = "application/json"
      request["X-Requested-With"] = "XMLHttpRequest"
      request["Accept"] = "application/json"

      # the only thing that matters for auth is this _instacart_session
      request["Cookie"] = session_cookie
    end
  end
end
