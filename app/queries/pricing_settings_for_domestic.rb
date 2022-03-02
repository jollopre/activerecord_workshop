module Queries
  class PricingSettingsForDomestic
    def initialize(storage = ORM::PricingSetting)
      @storage = storage
    end

    def call(company_code:, country_code:)
      @storage
        .joins(:company)
        .joins(:payment_option)
        .where(companies: { code: company_code })
        .where(country_code: country_code)
        .where("companies.currency_code = payment_options.currency_code")
        # .where(
        #   companies[:currency_code].eq(payment_options[:currency_code])
        # )
    end

    private

    def companies
      ORM::Company.arel_table
    end

    def payment_options
      ORM::PaymentOption.arel_table
    end
  end
end
