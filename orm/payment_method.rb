module ORM
  class PaymentMethod < ActiveRecord::Base
    enum _type: [:debit_card, :credit_card, :eft, :direct_credit, :direct_debit]
    class << self
      def credit_card
        where(_type: :credit_card)
      end
    end
  end
end
