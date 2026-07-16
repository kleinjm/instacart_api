# frozen_string_literal: true

module InstacartApi
  # Base class for every error the gem raises.
  class Error < StandardError; end

  # A non-200 HTTP response from Instacart.
  class ResponseError < Error; end

  # A 200 response whose GraphQL body carried an `errors` array.
  class GraphqlError < Error; end

  # A request for an operation we have no persisted-query hash for.
  # Usually means the captured hashes are stale — re-run the capture script.
  class UnknownOperationError < Error; end
end
