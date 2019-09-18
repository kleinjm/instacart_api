# frozen_string_literal: true

require "instacart_api/version"
require "json"
require "net/http"
require "uri"

Dir["./lib/instacart_api/actions/*.rb"].each { |file| require file }

module InstacartApi
  class Error < StandardError; end

  class Client
    include InstacartApi::AddItemToCart
    include InstacartApi::Search

    BASE_DOMAIN = "https://www.instacart.com"
    REQ_OPTIONS = { use_ssl: true }.freeze
    COOKIE_SESSION_NAME = "_instacart_session"

    def initialize(email:, password:, default_store:)
      @email = email
      @password = password
      @default_store = default_store
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

    attr_reader :email, :password, :default_store

    class ResponseError < StandardError; end

    def session_token
      @session_token ||=
        login_response.fetch("set-cookie")[/#{COOKIE_SESSION_NAME}=(.*?);/m, 1]
    end

    def login_response
      return @login_response if defined?(@login_response)

      uri = URI.parse("#{BASE_DOMAIN}/accounts/login")
      request = Net::HTTP::Post.new(uri)

      request.body = JSON.dump(user: { email: email, password: password })

      @login_response =
        perform_request(uri: uri, request: request, with_auth: false)
    end

    def perform_request(uri:, request:, with_auth: true)
      configure_request(request: request, with_auth: with_auth)
      response = Net::HTTP.start(uri.hostname, uri.port, REQ_OPTIONS) do |http|
        http.request(request)
      end

      unless response.code.match?("200")
        raise ResponseError, JSON.parse(response.body)
      end

      response
    end

    def configure_request(request:, with_auth:)
      request.content_type = "application/json"
      request["X-Requested-With"] = "XMLHttpRequest"
      request["Accept"] = "application/json"

      # the only thing that matters for auth is this _instacart_session
      request["Cookie"] = session_cookie if with_auth
    end

    def session_cookie
      "#{COOKIE_SESSION_NAME}=#{session_token}"
    end
  end
end
