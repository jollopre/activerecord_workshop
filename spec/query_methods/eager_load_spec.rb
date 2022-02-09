RSpec.describe "eager_load" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:pricing_settings) do
    FactoryBot.create_list(:pricing_setting, 2, company: company)
  end

  it 'loads a company and its pricing_settings' do
    r = ORM::Company
      .where(code: company.code)
      .eager_load(:pricing_settings)

    expect(r).to include(
      have_attributes(
        code: company.code,
        pricing_settings: pricing_settings
      )
    )
  end

  it 'company and pricing_settings are loaded in a single SQL query' do
    sql = ORM::Company
      .where(code: company.code)
      .eager_load(:pricing_settings)
      .to_sql

    expect(sql).to include(
      "FROM `companies` LEFT OUTER JOIN `pricing_settings` ON `pricing_settings`.`company_code` = `companies`.`code`"
    )
  end

  context 'when a company does not have pricing_settings' do
    let!(:company2) { FactoryBot.create(:company) }

    it 'the company is still loaded' do
      r = ORM::Company
        .where(code: company2.code)
        .eager_load(:pricing_settings)

      expect(r).to include(
        have_attributes(
          code: company2.code,
          pricing_settings: []
        )
      )
    end
  end

  context 'conditions on `pricing_settings`' do
    it 'are permitted' do
      r = ORM::Company
        .where(code: company.code, pricing_settings: { id: nil })
        .eager_load(:pricing_settings)
        .to_a

      expect(r).to be_empty
    end
  end
end
