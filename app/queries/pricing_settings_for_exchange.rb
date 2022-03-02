module Queries
  class PricingSettingsForExchange
    def initialize(storage = ORM::PricingSetting)
      @storage = storage
    end

    def call(company_code:, country_code:)
    end
  end
end
