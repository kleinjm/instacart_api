# frozen_string_literal: true

module InstacartApi
  # Instacart's web client sends Apollo *persisted queries*: instead of the
  # full GraphQL document, it sends an operation name plus a SHA-256 hash the
  # server already knows. The server rejects unknown hashes
  # ("PersistedQueryNotSupported"), so we must send the exact hashes the live
  # client uses.
  #
  # These hashes are tied to a frontend build and rotate when Instacart
  # deploys. When calls start failing with UnknownOperationError or
  # GraphqlError, refresh them by re-running the capture script (see
  # capture/README.md) and pasting the new values here.
  module PersistedQueries
    HASHES = {
      "SearchCrossRetailerGroupResults" =>
        "0ef32d339ed761d8609b91d8232a26b7b6b05206baf32694c6fa47f7f8e73a33",
      "Items" =>
        "9ad66078d7fa81276b6bd4eb6a6f6fcdd1f4022ff0c3f5b4663c62877f06692a",
      "UpdateCartItemsMutation" =>
        "ba4bf465d294d1d528d82a4ac48ac13980d528149874c0e52082dc1d833bdb09",
      "PersonalActiveCarts" =>
        "eac9d17bd45b099fbbdabca2e111acaf2a4fa486f2ce5bc4e8acbab2f31fd8c0"
    }.freeze

    # The persisted-query hash for an operation, or raise if we don't have one.
    def self.hash_for(operation)
      HASHES.fetch(operation) do
        raise UnknownOperationError,
              "No persisted-query hash for #{operation.inspect}. " \
              "The captured hashes may be stale — re-run the capture script."
      end
    end
  end
end
