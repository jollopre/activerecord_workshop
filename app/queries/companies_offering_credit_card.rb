module Queries
  class CompaniesOfferingCreditCard
    def initialize(storage = ORM::Company)
      @storage = storage
    end

    # Companies offering credit_card as payment method
    def call
      @storage
        .joins(pricing_settings: { payment_option: :payment_method })
        .where(payment_methods: { _type: :credit_card })
        .distinct
    end
  end
end
