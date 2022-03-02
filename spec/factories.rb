require 'faker'

FactoryBot.define do
  factory :company, class: ORM::Company do
    code { Faker::Name.unique.initials }
    name { Faker::Company.name }
    sector { :InformationTechnology }
    association :currency, factory: :currency
  end

  factory :currency, class: ORM::Currency do
    code { Faker::Currency.unique.code }
    name { Faker::Currency.name }
  end

  factory :country, class: ORM::Country do
    code { Faker::Lorem.characters(number: 4) }
    name { Faker::Lorem.characters(number: 10) }
  end

  factory :payment_method, class: ORM::PaymentMethod do
    code { SecureRandom.uuid }
    name { Faker::Bank.name }
    _type { :credit_card }
  end

  factory :payment_option, class: ORM::PaymentOption do
    association :currency, factory: :currency
    association :payment_method, factory: :payment_method
  end

  factory :pricing_setting, class: ORM::PricingSetting do
    spread_unit_rate { 0 }
    fee do
      ORM::Fee.new(
        type: 'absolute',
        value_unit_rate: 0,
        value: 150
      )
    end
    association :company, factory: :company
    association :country, factory: :country
    association :payment_option, factory: :payment_option
  end
end
