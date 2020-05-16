# frozen_string_literal: true

module ApiSupport
  def stub_login
    body = File.read("spec/artifacts/successful_login_response_body.txt")
    cookie = File.read("spec/artifacts/successful_login_response_cookie.txt").strip

    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: body, headers: { "set-cookie" => cookie  })
  end

  def stub_search(term: "grapes")
    stub_request(:get, "https://www.instacart.com/v3/containers/fairway/search_v3/#{term}?page=1&per=40").
      to_return(status: 200, body: search_json_body, headers: {})
  end

  private

  def search_json_body
    "{\"container\":{\"modules\":[{\"id\":\"search_result_set_\", " \
      "\"data\":{\"items\":{}, \"pagination\":{\"total_pages\":1}}}]}}"
  end
end

RSpec.configure do |config|
  config.include ApiSupport
end
