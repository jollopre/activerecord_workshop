require 'app/queries/pricing_settings_for_domestic'

RSpec.describe Queries::PricingSettingsForDomestic do
  let!(:usd) { FactoryBot.create(:currency, code: "USD", name: "United States Dollard") }
  let!(:company) { FactoryBot.create(:company, currency: usd) }
  let!(:us) { FactoryBot.create(:country, code: "US", name: "United States") }
  let!(:payment_option1) { FactoryBot.create(:payment_option, currency: usd) }
  let!(:pricing_setting1) { FactoryBot.create(:pricing_setting, country: us, payment_option: payment_option1, company: company) }
  let!(:pricing_setting2) { FactoryBot.create(:pricing_setting, country: us, company: company) }

  it "return pricing_settings from a company in a country which do not involve different currency" do
    result = described_class.new.call(
      company_code: company.code,
      country_code: us.code
    )

    expect(result).to contain_exactly(
      have_attributes(id: pricing_setting1.id)
    )
  end
end
