module Queries
  class PricingSettingsForExchange
    def initialize(storage = ORM::PricingSetting)
      @storage = storage
    end

    def call(company_code:, country_code:)
      @storage
        .joins(:company)
        .joins(:payment_option)
        .where(country_code: country_code)
        .where(company_code: company_code)
        .where('companies.currency_code != payment_options.currency_code')
    end
  end
end
