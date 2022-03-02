require 'app/queries/pricing_settings_for_exchange'

RSpec.describe Queries::PricingSettingsForExchange do
  let!(:usd) { FactoryBot.create(:currency, code: "USD", name: "United States Dollard") }
  let!(:eur) { FactoryBot.create(:currency, code: "EUR", name: "Euro") }
  let!(:company) { FactoryBot.create(:company, currency: usd) }
  let!(:es) { FactoryBot.create(:country, code: "ES", name: "Spain") }
  let!(:payment_option1) { FactoryBot.create(:payment_option, currency: eur) }
  let!(:payment_option2) { FactoryBot.create(:payment_option, currency: usd) }
  let!(:pricing_setting1) { FactoryBot.create(:pricing_setting, country: es, payment_option: payment_option1, company: company) }
  let!(:pricing_setting2) { FactoryBot.create(:pricing_setting, country: es, payment_option: payment_option2, company: company) }

  it "return pricing_settings from a company in a country which involve different currency" do
    result = described_class.new.call(
      company_code: company.code,
      country_code: es.code
    )

    expect(result).to contain_exactly(
      have_attributes(id: pricing_setting1.id)
    )
  end
end
