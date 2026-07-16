# frozen_string_literal: true

module InstacartApi
  # Thin transport over Instacart's GraphQL endpoint.
  #
  # Authentication is the logged-in session cookie (the
  # `__Host-instacart_sid` cookie, plus its companions) captured from a real
  # browser login — Instacart's login flow is bot-protected and can't be
  # scripted, so the caller supplies the cookie string. Every request also
  # needs the `X-Client-Identifier: web` header, without which the
  # persisted-query resolver rejects the variables.
  class GraphqlClient
    ENDPOINT = URI("https://www.instacart.com/graphql")

    # A recent desktop Chrome UA; Instacart serves the web GraphQL API to it.
    DEFAULT_USER_AGENT =
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) " \
      "AppleWebKit/537.36 (KHTML, like Gecko) " \
      "Chrome/126.0.0.0 Safari/537.36"

    def initialize(session_cookie:, user_agent: DEFAULT_USER_AGENT)
      @session_cookie = session_cookie
      @user_agent = user_agent
    end

    # Run a persisted query (HTTP GET). Returns the `data` hash.
    def query(operation, variables)
      uri = ENDPOINT.dup
      uri.query = URI.encode_www_form(
        operationName: operation,
        variables: JSON.generate(variables),
        extensions: JSON.generate(extensions(operation))
      )
      perform(Net::HTTP::Get.new(uri))
    end

    # Run a persisted mutation (HTTP POST). Returns the `data` hash.
    def mutate(operation, variables)
      request = Net::HTTP::Post.new(ENDPOINT)
      request.body = JSON.generate(
        operationName: operation,
        variables: variables,
        extensions: extensions(operation)
      )
      perform(request)
    end

    private

    attr_reader :session_cookie, :user_agent

    def extensions(operation)
      {
        persistedQuery: {
          version: 1,
          sha256Hash: PersistedQueries.hash_for(operation)
        }
      }
    end

    def perform(request)
      configure(request)

      response = Net::HTTP.start(
        ENDPOINT.hostname, ENDPOINT.port, use_ssl: true
      ) { |http| http.request(request) }

      unless response.code == "200"
        raise ResponseError, "Instacart responded with HTTP #{response.code}"
      end

      parse(response.body)
    end

    def configure(request)
      request["Accept"] = "application/json"
      request["Content-Type"] = "application/json"
      request["X-Client-Identifier"] = "web"
      request["X-Requested-With"] = "XMLHttpRequest"
      request["User-Agent"] = user_agent
      request["Cookie"] = session_cookie
    end

    def parse(body)
      json = JSON.parse(body)

      if (errors = json["errors"])
        messages = errors.map { |error| error["message"] }.join("; ")
        raise GraphqlError, messages
      end

      json.fetch("data")
    end
  end
end
