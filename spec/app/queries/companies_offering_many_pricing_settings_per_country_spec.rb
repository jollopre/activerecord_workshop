require 'app/queries/companies_offering_many_pricing_settings_per_country'

RSpec.describe Queries::CompaniesOfferingManyPricingSettingsPerCountry do
  let(:company1) { FactoryBot.create(:company) }
  let(:company2) { FactoryBot.create(:company) }

  before do
    es = FactoryBot.create(:country, code: 'ES')
    us = FactoryBot.create(:country, code: 'US')
    FactoryBot.create(:pricing_setting, country: es, company: company1)
    FactoryBot.create(:pricing_setting, country: es, company: company1)
    FactoryBot.create(:pricing_setting, country: us, company: company1)
    FactoryBot.create(:pricing_setting, country: us, company: company2)
  end

  it 'return company_code/country_code and its count of pricing_settings if there are more than 1 per group' do
    result = described_class.new.call

    expect(result).to contain_exactly(
      [company1.code, "ES"]
    )
  end
end
