require_relative 'companies_offering_many_pricing_settings_per_country'

module Queries
  class CompanyOffersForCountry
    def initialize(storage = ORM::PricingSetting)
      @storage = storage
    end

    def call(company_code:, country_code:)
      result = @storage
        .where(company_code: company_code)
        .where(country_code: country_code)
        .includes(payment_option: [:currency, :payment_method])
        .references(:payment_options, :currencies, :payment_methods)
      result.map { |orm_pricing_setting| build_offer_attrs(orm_pricing_setting) }
    end

    private

    def build_offer_attrs(orm_pricing_setting)
      {
        spread_unit_rate: orm_pricing_setting.spread_unit_rate,
        fee: {
          type: orm_pricing_setting.fee.type,
          value_unit_rate: orm_pricing_setting.fee.value_unit_rate,
          value: orm_pricing_setting.fee.value
        },
        payment_method: build_payment_method_attrs(
          orm_pricing_setting.payment_option)
      }
    end

    def build_payment_method_attrs(orm_payment_option)
      payment_method = orm_payment_option.payment_method
      {
        currency: build_currency(orm_payment_option.currency),
        name: payment_method.name,
        type: payment_method._type
      }
    end

    def build_currency(orm_currency)
      {
        code: orm_currency.code,
        name: orm_currency.name
      }
    end

    class << self
      def call
        company_code, country_code = CompaniesOfferingManyPricingSettingsPerCountry.new.call.first
        
        Infra.logger.info({ message: "Retrieved first company with more than one pricing_setting for a country", details: { company_code: company_code, country_code: country_code }})

        new.call(company_code: company_code, country_code: country_code)
      end
    end
  end
end
