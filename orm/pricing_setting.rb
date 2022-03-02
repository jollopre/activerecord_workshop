module ORM
  class PricingSetting < ActiveRecord::Base
    belongs_to :country, foreign_key: :country_code
    belongs_to :company, foreign_key: :company_code, counter_cache: true
    belongs_to :payment_option
    serialize :fee, Fee

    class << self
      def credit_card
        self
          .joins(:payment_option)
          .merge(PaymentOption.credit_card)
      end
    end
  end
end
