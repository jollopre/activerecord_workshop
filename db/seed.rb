require 'json'
require 'securerandom'

delete_records = lambda do
  ORM::PricingSetting.delete_all
  ORM::Company.delete_all
  ORM::PaymentOption.delete_all
  ORM::Country.delete_all
  ORM::Currency.delete_all
  ORM::PaymentMethod.delete_all
  puts "records from tables deleted"
end

seed_countries = lambda do
  serialized_countries = File.read('datasets/countries.json')
  countries = JSON.parse(serialized_countries, symbolize_names: true)
  sanitized_countries = countries.reduce([]) do |acc, country|
    code, name = country.values_at(:Code, :Name)
    if code.present? && name.present?
      acc << { code: code, name: name }
    end
    acc
  end
  ORM::Country.insert_all(sanitized_countries, record_timestamps: true)
  puts "`countries` inserted"
end

seed_currencies = lambda do
  serialized_currencies = File.read('datasets/currencies.json')
  currencies = JSON.parse(serialized_currencies, symbolize_names: true)
  sanitized_currencies = currencies.reduce([]) do |acc, currency|
    code, name, withdrawn = currency.values_at(:AlphabeticCode, :Currency, :WithdrawalDate)
    if withdrawn.nil? && code.present? && name.present?
      acc << { code: code, name: name }
    end
    acc
  end
  ORM::Currency.insert_all(sanitized_currencies, record_timestamps: true)
  puts "`currencies` inserted"
end

seed_companies = lambda do
  serialized_companies = File.read('datasets/companies.json')
  companies = JSON.parse(serialized_companies, symbolize_names: true)
  currency_codes = ORM::Currency.pluck(:code)
  sanitized_companies = companies.reduce([]) do |acc, company|
    code, name, sector = company.values_at(:Symbol, :Name, :Sector)
    acc << {
      code: code,
      name: name,
      sector: sector.gsub(/\s/, ''),
      currency_code: currency_codes.sample
    }
  end
  ORM::Company.insert_all(sanitized_companies, record_timestamps: true)
  puts "`companies` inserted"
end

seed_payment_methods = lambda do
  serialized_payment_methods = File.read('datasets/payment_methods.json')
  payment_methods = JSON.parse(serialized_payment_methods, symbolize_names: true)
  sanitized_payment_methods = payment_methods.reduce([]) do |acc, payment_method|
    name, type = payment_method.values_at(:name, :type)
    acc << {
      code: SecureRandom.uuid,
      name: name,
      _type: type
    }
  end
  ORM::PaymentMethod.insert_all(sanitized_payment_methods, record_timestamps: true)
  puts "`payment_methods` inserted"
end

seed_payment_options = lambda do
  currency_codes = ORM::Currency.pluck(:code)
  currency_code_size = currency_codes.size
  payment_method_codes = ORM::PaymentMethod.pluck(:code)
  payment_method_size = payment_method_codes.size
  payment_method_codes.each.with_index do |payment_method_code, index|
    payment_options = []
    currency_codes_sample = currency_codes.sample(Random.rand(currency_code_size))
    currency_codes_sample.each do |currency_code|
      payment_options << {
        currency_code: currency_code,
        payment_method_code: payment_method_code
      }
    end
    ORM::PaymentOption.insert_all(payment_options, record_timestamps: true)
    puts "`payment_options` for payment method `#{payment_method_code}` inserted. Progress (#{index+1}/#{payment_method_size})"
  end
end

seed_pricing_settings = lambda do
  company_codes = ORM::Company.pluck(:code)
  company_sample_size = [5, company_codes.size].min
  company_code_sample = company_codes.sample(company_sample_size)
  country_codes = ORM::Country.pluck(:code)
  country_code_size = country_codes.size
  payment_option_ids = ORM::PaymentOption.pluck(:id)
  payment_option_size = payment_option_ids.size
  company_code_sample.each.with_index do |company_code, index|
    country_codes_sample = country_codes.sample(Random.rand(country_code_size))
    payment_options_sample = payment_option_ids.sample(Random.rand(payment_option_size))
    pricing_settings = []
    country_codes_sample.each do |country_code|
      payment_options_sample.each do |payment_option_id|
        pricing_settings << {
          company_code: company_code,
          country_code: country_code,
          payment_option_id: payment_option_id,
          spread_unit_rate: Random.rand,
           fee: ORM::Fee.new(
             { type: 'absolute', value_unit_rate: 0.0, value: 0 }
           )
        }
      end
    end

    unless pricing_settings.empty?
      ORM::PricingSetting.insert_all(pricing_settings, record_timestamps: true)
      puts "`pricing_settings` for company `#{company_code}` inserted. Progress (#{index+1}/#{company_sample_size})"
    end
  end
end

delete_records.call
seed_countries.call
seed_currencies.call
seed_companies.call
seed_payment_methods.call
seed_payment_options.call
seed_pricing_settings.call
