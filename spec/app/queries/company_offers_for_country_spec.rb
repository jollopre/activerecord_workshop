require 'app/queries/company_offers_for_country'

RSpec.describe Queries::CompanyOffersForCountry do
  let!(:es) { FactoryBot.create(:country, code: 'ES') }
  let!(:company1) { FactoryBot.create(:company) }
  let!(:company2) { FactoryBot.create(:company) }
  let!(:payment_option1) { FactoryBot.create(:payment_option) }
  let!(:payment_option2) { FactoryBot.create(:payment_option) }
  let!(:pricing_setting1) { FactoryBot.create(:pricing_setting, company: company1, payment_option: payment_option1, country: es) }
  let!(:pricing_setting2) { FactoryBot.create(:pricing_setting, company: company1, payment_option: payment_option2, country: es) }

  before do
    payment_option3 = FactoryBot.create(:payment_option)
    FactoryBot.create(:pricing_setting, company: company1, payment_option: payment_option2)
    FactoryBot.create(:pricing_setting, company: company2, payment_option: payment_option3)
  end

  it 'returns offers for a company in a country' do
    result = described_class.new.call(company_code: company1.code, country_code: es.code)

    expect(result).to contain_exactly(
      hash_including(
        spread_unit_rate: pricing_setting1.spread_unit_rate,
        fee: include(
          type: 'absolute',
          value_unit_rate: 0,
          value: 150
        ),
        payment_method: include(
          currency: include(
            code: payment_option1.currency.code,
            name: payment_option1.currency.name
          ),
          name: payment_option1.payment_method.name,
          type: payment_option1.payment_method._type
        )
      ),
      hash_including(
        spread_unit_rate: pricing_setting2.spread_unit_rate,
        fee: include(
          type: 'absolute',
          value_unit_rate: 0,
          value: 150
        ),
        payment_method: include(
          currency: include(
            code: payment_option2.currency.code,
            name: payment_option2.currency.name
          ),
          name: payment_option2.payment_method.name,
          type: payment_option2.payment_method._type
        )
      )
    )
  end
end
