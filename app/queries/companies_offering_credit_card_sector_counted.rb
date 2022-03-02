module Queries
  class CompaniesOfferingCreditCardSectorCounted
    def initialize(storage = ORM::Company)
      @storage = storage
    end

    # Companies offering credit_card as payment method by sector
    def call
      @storage
        .select(:code)
        .joins(pricing_settings: { payment_option: :payment_method })
        .where(payment_methods: { _type: :credit_card })
        .distinct
        .group(:sector)
        .count
    end
  end
end
