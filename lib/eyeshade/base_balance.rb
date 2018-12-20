# frozen_string_literal: true
module Eyeshade
  class BaseBalance
    attr_reader :rates,
                :default_currency,
                :amount_probi,
                :amount_bat,
                :amount_default_currency,
                :fees_probi,
                :fees_bat,
                :fees_default_currency

    # Account types
    CHANNEL = "channel"
    OWNER = "owner"

    def initialize(rates, default_currency)
      @rates = rates
      @default_currency = default_currency
    end

    private

    # Expects an Integer and returns a BigDecimal
    def probi_to_bat(probi)
      probi.to_d / 1E18
    end

    # Expects a BigDecimal returns an Integer
    def bat_to_probi(bat)
      (bat * BigDecimal.new('1.0e18')).to_i
    end

    # Expects and returns values with probi unit
    def calculate_fees(total_probi)
      fees_probi = (total_probi * fee_rate).to_i
      amount_probi = total_probi - fees_probi
      {"amount" => amount_probi, "fees" => fees_probi}
    end

    # Expects and returns BigDecimals
    def convert(amount_bat, currency)
      return amount_bat if currency == "BAT"
      return if @rates[currency].nil?
      amount_bat * @rates[currency]
    end

    def fee_rate
      Rails.application.secrets[:fee_rate].to_d
    end
  end
end
