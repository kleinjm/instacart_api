# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

require "instacart_api/version"
require "instacart_api/errors"
require "instacart_api/persisted_queries"
require "instacart_api/graphql_client"
require "instacart_api/models/item"
require "instacart_api/models/search_result"
require "instacart_api/models/cart"
require "instacart_api/client"

# Ruby wrapper around Instacart's (undocumented) web GraphQL API.
module InstacartApi
end
