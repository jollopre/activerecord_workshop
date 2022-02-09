module ORM
  class Company < ActiveRecord::Base
    enum sector: [:Industrials, :HealthCare, :InformationTechnology, :CommunicationServices, :ConsumerStaples, :ConsumerDiscretionary, :Utilities, :Financials, :Materials, :RealEstate, :Energy]
    belongs_to :currency, foreign_key: :currency_code
    has_many :pricing_settings, foreign_key: :company_code
    has_many :payment_options, through: :pricing_settings

    class << self
      def credit_card_merge
        self
          .joins(:pricing_settings)
          .merge(PricingSetting.credit_card)
          .distinct
      end
    end
  end
end
