require 'addressable/template'
require 'json'

module Promo
  module Models
    class PeerToPeerRegistration < Client
      # For more information about how these URI templates are structured read the explaination in the RFC
      # https://www.rfc-editor.org/rfc/rfc6570.txt
      PATH = Addressable::Template.new("api/2/promo/referral_code/p2p/{id}")

      # Creates a new owner
      # @param [String] id The owner identifier
      def create(publisher:, promo_campaign:)
        response = put(PATH.expand(id: publisher.owner_identifier))
        payload = JSON.parse(response.body)
        payload.each do |promo_registration|
          PromoRegistration.create!(
            referral_code: promo_registration["referral_code"],
            publisher_id: publisher.id,
            promo_id: Rails.application.secrets[:active_promo_id],
            promo_campaign_id: promo_campaign.id,
            kind: PromoRegistration::PEER_TO_PEER
          )
        end
      end
    end
  end
end