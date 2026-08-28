module Notifications
  class RngWinner < ::Notification
    self.default_priority     = :low
    self.aggregatable         = false
    self.category_key         = :rng_winner
    self.category_label       = "RNG Winner achievement"
    self.category_description = "One-time notice that you hold the RNG Winner achievement"
    self.category_group       = "General"

    # The shop item that redeems the RNG Winner prize.
    PRIZE_SHOP_ITEM_ID = 290

    def slack_message
      "🎉 Congratulations! You got first place in the RNG! Redeem your prize here: #{prize_url}"
    end

    def preview_text
      "Congratulations! You got first place in the RNG! Redeem your prize here."
    end

    def preview_path
      Rails.application.routes.url_helpers.shop_item_path(PRIZE_SHOP_ITEM_ID)
    end

    def email_subject
      "Congratulations! You got first place in the RNG!"
    end

    private

    def prize_url
      Rails.application.routes.url_helpers.shop_item_url(
        PRIZE_SHOP_ITEM_ID, host: "stardance.hackclub.com", protocol: "https"
      )
    end
  end
end
