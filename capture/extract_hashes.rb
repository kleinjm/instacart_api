# frozen_string_literal: true

# Reads calls.jsonl (produced by capture.js) and prints the persisted-query
# hashes for the operations the gem uses, formatted to paste straight into
# lib/instacart_api/persisted_queries.rb.
#
#   ruby extract_hashes.rb

require "json"
require "uri"

OPERATIONS = %w[
  SearchCrossRetailerGroupResults
  Items
  UpdateCartItemsMutation
  PersonalActiveCarts
].freeze

calls_path = File.join(__dir__, "calls.jsonl")
unless File.exist?(calls_path)
  abort "Missing #{calls_path} — run capture.js first."
end

hashes = {}

File.foreach(calls_path) do |line|
  line = line.strip
  next if line.empty?

  call = JSON.parse(line)
  operation = nil
  extensions = nil

  if call["post"]
    begin
      body = JSON.parse(call["post"])
    rescue JSON::ParserError
      next
    end
    operation = body["operationName"]
    extensions = body["extensions"]
  else
    query = URI.decode_www_form(URI(call["url"]).query || "").to_h
    operation = query["operationName"]
    raw = query["extensions"]
    extensions = JSON.parse(raw) if raw
  end

  next unless OPERATIONS.include?(operation)

  sha = extensions&.dig("persistedQuery", "sha256Hash")
  hashes[operation] = sha if sha
end

missing = OPERATIONS - hashes.keys
warn "WARNING: no hash captured for #{missing.join(', ')}" unless missing.empty?

puts "    HASHES = {"
puts hashes.map { |op, sha| %(      "#{op}" =>\n        "#{sha}") }.join(",\n")
puts "    }.freeze"
