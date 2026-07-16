# Refreshing persisted-query hashes

Instacart's web client uses Apollo **persisted queries**: it sends an operation
name plus a SHA-256 hash instead of the full GraphQL document, and the server
only honors hashes it already knows. Those hashes change every time Instacart
ships a new frontend build, so `lib/instacart_api/persisted_queries.rb` goes
stale periodically — you'll see `GraphqlError`/`UnknownOperationError` when it
does.

This directory holds a tool to recapture them from a real browser session.

## Usage

```bash
cd capture
npm install playwright
npx playwright install chromium

node capture.js      # opens a browser — log in, then search + add an item
ruby extract_hashes.rb
```

`capture.js` records every `/graphql` call to `calls.jsonl` while you drive the
shopping flow. `extract_hashes.rb` reads that file and prints an updated
`HASHES = { ... }` block. Paste it into
`lib/instacart_api/persisted_queries.rb`, run the specs, and commit.

## Notes

- `calls.jsonl` contains data from your authenticated session and is gitignored
  — don't commit it.
- If `extract_hashes.rb` warns that an operation is missing, you didn't exercise
  that part of the flow (e.g. you never added an item, so
  `UpdateCartItemsMutation` wasn't fired). Re-run and complete every step.
