# frozen_string_literal: true

class Client
  def add_item_to_cart(item:, quantity:)
    response = put(
      url: "v3/carts/#{cart_id}/update_items",
      payload: {
        "items" => [
          {
            "item_id" => "item_31508130",
            "quantity" => quantity,
            "source_type" => "store_root_department",
            "source_value" => "dynamic_list_buy_it_again",
            "tracking" => {
              "source_type" => "store_root_department",
              "source_value" => "dynamic_list_buy_it_again",
              "analytics_debug" => false,
              "api_version" => "3",
              "country_id" => 840,
              "currency" => "USD",
              "guest" => false,
              "inventory_area_id" => 362,
              "inventory_area_id_list" => [
                362
              ],
              "is_new_user" => false,
              "platform" => "mobile_web",
              "region" => "NYC",
              "region_id" => 6,
              "service_type" => "delivery",
              "user_id" => 22552567,
              "warehouse_id" => 53,
              "warehouse_id_list" => [
                53
              ],
              "whitelabel_id" => 1,
              "whitelabel_retailer" => "instacart",
              "wl_exclusive" => "instacart",
              "zip_active" => true,
              "zip_code" => "11215",
              "zone_id" => 973,
              "ahoy_visit_token" => "8c830735-fa51-486d-b2d5-7710c7d0aeed",
              "ahoy_visitor_token" => "5cc96b07-dd5b-425a-bf7f-aac160fbd4ad",
              "m_id" => "70264df345a93048de9e5c4b36751ad5e4991ca0b8944300ea84b9d203798944",
              "user_channel_1" => "store",
              "store" => "fairway-market",
              "source1" => [
                "delivery",
                "pickup"
              ],
              "product_flow" => "store",
              "page_view_id" => "76023af3-8be5-4ecc-aa6e-07f9419806c0",
              "cart_id" => 669807,
              "cart_instance_id" => "213f01133e197fc08410cb28a41a9763",
              "serializer_class" => "api_v3/page_modules/items_list_serializer",
              "item_id" => 31508130,
              "original_position" => 1,
              "availability_model_score" => 0.938,
              "item_card_impression_id" => "f5f9f41a-e9cd-490f-9f0a-faf8d18f8dbf",
              "product_id" => 3343053,
              "cartQty" => 0,
              "qtyDiff" => 1
            },
            "item_tasks" => [],
          }
        ],
        "request_timestamp" => 1568747533628
      }
    )
  end

  private

  def cart_id
    @cart_id ||=
      JSON.parse(login_response.body).dig("data", "bootstrap_cart", "id")
  end
end
