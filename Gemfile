# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby File.read("./.ruby-version").strip

# Specify your gem's dependencies in instacart_api.gemspec
gemspec

group :development do
  gem "jcop", "~> 0.3.0", git: "https://github.com/kleinjm/jcop"
end
