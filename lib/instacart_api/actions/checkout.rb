# frozen_string_literal: true

class Client
  def checkout
    uri = URI.parse("https://www.instacart.com/v3/containers/checkout?cache_key=c3f872-362-f-963")
    request = Net::HTTP::Get.new(uri)
    request.content_type = "application/json"
    request["X-Csrf-Token"] = "vwHHh8rQbgmR6/8+RigyxTykHBaTrFWjjoWzKUc9YGMkz7klJ10e7d/ZBd8Osb3QmQtZVsWlkKgOaKth2x2mCQ=="
    request["Accept-Language"] = "en-US,en;q=0.9"
    request["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36"
    request["Accept"] = "application/json"
    request["Referer"] = "https://www.instacart.com/store/checkout_v3"
    request["X-Client-Identifier"] = "web"
    request["Authority"] = "www.instacart.com"
    request["X-Requested-With"] = "XMLHttpRequest"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end
end
