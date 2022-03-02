module ORM
  class PaymentOption < ActiveRecord::Base
    belongs_to :currency, foreign_key: :currency_code
    belongs_to :payment_method, foreign_key: :payment_method_code

    class << self
      def credit_card
        self
          .joins(:payment_method)
          .merge(PaymentMethod.credit_card)
      end
    end
  end
end
