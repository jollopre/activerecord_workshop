require 'app/queries/companies_offering_payment_methods_above_avg_spread'

RSpec.describe Queries::CompaniesOfferingPaymentMethodsAboveAvgSpread do
  let(:company1) { FactoryBot.create(:company) }
  let(:company2) { FactoryBot.create(:company) }

  before do
    payment_method1 = FactoryBot.create(:payment_method, _type: :credit_card)
    payment_method2 = FactoryBot.create(:payment_method, _type: :debit_card)
    payment_option1 = FactoryBot.create(:payment_option, payment_method: payment_method1)
    payment_option2 = FactoryBot.create(:payment_option, payment_method: payment_method1)
    payment_option3 = FactoryBot.create(:payment_option, payment_method: payment_method2)
    FactoryBot.create(:pricing_setting, company: company1, payment_option: payment_option1, spread_unit_rate: 0.01)
    FactoryBot.create(:pricing_setting, company: company2, payment_option: payment_option3, spread_unit_rate: 0.02)
    FactoryBot.create(:pricing_setting, company: company1, payment_option: payment_option2, spread_unit_rate: 0.10)
  end

  it 'return companies offering payment methods above average spread of pricing_settings' do
    result = described_class.new.call

    expect(result.to_a).to contain_exactly(
      have_attributes(code: company1.code)
    )
  end
end
