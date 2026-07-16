# Changelog

## 0.2.0

Complete rewrite for Instacart's modern web GraphQL API.

- **Auth:** session-cookie based (`session_cookie:`) instead of scripted
  email/password login, which is now bot-protected.
- **Transport:** `GraphqlClient` speaks Instacart's Apollo persisted-query
  protocol; hashes live in `PersistedQueries` and are refreshable via the
  `capture/` tooling.
- **Client operations:** `#search`, `#items`, `#add_item_to_cart`,
  `#add_items_to_cart`, `#active_carts`, returning `Item`, `SearchResult`, and
  `Cart` models.
- Removed the legacy `#login`, `#available_stores`, and v3 container endpoints.
- Modernized tooling: Ruby 4.0, GitHub Actions CI, RuboCop, 100% test coverage,
  and a RubyGems trusted-publishing release workflow.
