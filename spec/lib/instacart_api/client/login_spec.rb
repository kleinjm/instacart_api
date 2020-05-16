# frozen_string_literal: true

RSpec.describe InstacartApi::Client::Login do
  describe "#login" do
    it "performs the login request and returns an instance of self" do
      stub_login

      client = InstacartApi::Client.
        new(email: "test@gmail.com", password: "testing1")

      expect(client.login).to be_an_instance_of(InstacartApi::Client)
      expect(client.instance_variable_get(:@session_cookie)).to_not be_nil
      expect(client.instance_variable_get(:@cart_id)).to_not be_nil
      expect(WebMock).to have_requested(:post, "https://www.instacart.com/accounts/login")
    end
  end
end
