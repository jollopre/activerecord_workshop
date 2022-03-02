module Queries
  class CompaniesOfferingPaymentMethodsAboveAvgSpread
    def initialize(storage = ORM::Company)
      @storage = storage
    end

    def call
      @storage
        .select(:code)
        .joins(:pricing_settings)
        .where(
          "pricing_settings.spread_unit_rate > (:spread_unit_rate_avg)",
          spread_unit_rate_avg: @storage
            .select("avg(spread_unit_rate)")
            .from("pricing_settings")
        )
        .distinct
    end
  end
end
