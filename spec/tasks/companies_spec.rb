load "tasks/companies.rake"

RSpec.describe "rake companies:compute_pricing_settings_count", type: :task do
  let!(:company1) { FactoryBot.create(:company) }
  let!(:company2) { FactoryBot.create(:company) }

  before do
    FactoryBot.create(:pricing_setting, company: company1)
    FactoryBot.create(:pricing_setting, company: company1)
    FactoryBot.create(:pricing_setting, company: company2)
    ORM::Company.update_all(pricing_settings_count: 0)
  end

  it "pricing_setting_count is updated for each company" do
    task.invoke

    company1.reload
    company2.reload
    expect(company1.pricing_settings_count).to eq(2)
    expect(company2.pricing_settings_count).to eq(1)
  end
end

RSpec.describe "rake companies:compute_pricing_settings_count_subquery", type: :task do
  let!(:company1) { FactoryBot.create(:company) }
  let!(:company2) { FactoryBot.create(:company) }

  before do
    FactoryBot.create(:pricing_setting, company: company1)
    FactoryBot.create(:pricing_setting, company: company1)
    FactoryBot.create(:pricing_setting, company: company2)
    ORM::Company.update_all(pricing_settings_count: 0)
  end

  it "pricing_setting_count is updated for each company" do
    task.invoke

    company1.reload
    company2.reload
    expect(company1.pricing_settings_count).to eq(2)
    expect(company2.pricing_settings_count).to eq(1)
  end
end
