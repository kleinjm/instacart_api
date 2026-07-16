# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "instacart_api/version"

Gem::Specification.new do |spec|
  spec.name          = "instacart_api"
  spec.version       = InstacartApi::VERSION
  spec.authors       = ["James Klein"]
  spec.email         = ["kleinjm007@gmail.com"]

  spec.summary       = %q{A Ruby wrapper for Instacart's API}
  spec.description   = %q{A Ruby wrapper for Instacart's API}
  spec.homepage      = "https://github.com/kleinjm/instacart_api"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.1"

  # Private gem — never push to a public gem host.
  spec.metadata["allowed_push_host"] = "https://none.invalid"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kleinjm/instacart_api"
  spec.metadata["changelog_uri"] = "https://github.com/kleinjm/instacart_api/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ostruct", "~> 0.6"

  spec.add_development_dependency "irb"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1.60"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "webmock", "~> 3.20"
end
