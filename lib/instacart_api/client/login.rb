# frozen_string_literal: true

module InstacartApi
  class Client
    module Login
      def login
        response = login_response

        session_token = response.fetch("set-cookie")[/#{COOKIE_SESSION_NAME}=(.*?);/m, 1]
        @session_cookie = "#{COOKIE_SESSION_NAME}=#{session_token}"
        @cart_id = JSON.parse(response.body).dig("data", "bootstrap_cart", "id")

        self
      end

      private

      COOKIE_SESSION_NAME = "_instacart_session"
      private_constant :COOKIE_SESSION_NAME

      def login_response
        uri = URI.parse("#{BASE_DOMAIN}/accounts/login")
        request = Net::HTTP::Post.new(uri)

        request.body = JSON.dump(user: { email: email, password: password })

        login_request(uri: uri, request: request)
      end

      def login_request(uri:, request:)
        configure_login_request(request: request)
        response = Net::HTTP.start(uri.hostname, uri.port, REQ_OPTIONS) do |http|
          http.request(request)
        end

        raise ResponseError unless response.code.match?("200")

        response
      end

      def configure_login_request(request:)
        request.content_type = "application/json"
        request["X-Requested-With"] = "XMLHttpRequest"
        request["Accept"] = "application/json"
      end
    end
  end
end
