# frozen_string_literal: true

module ApiSupport
  def stub_login
    body = File.read("spec/artifacts/successful_login_response_body.txt")
    cookie = File.read("spec/artifacts/successful_login_response_cookie.txt").strip

    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: body, headers: { "set-cookie" => cookie  })
  end
end

RSpec.configure do |config|
  config.include ApiSupport
end
