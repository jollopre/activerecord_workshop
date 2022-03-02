module Queries
  class CompaniesOfferingManyPricingSettingsPerCountry
    def initialize(storage = ORM::PricingSetting)
      @storage = storage
    end

    def call
      @storage
        .group(:company_code, :country_code)
        .having("count(id) > 1")
        .pluck(:company_code, :country_code)
    end
  end
end
