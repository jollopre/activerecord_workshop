RSpec.describe "joins" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:pricing_settings) do
    FactoryBot.create_list(:pricing_setting, 2, company: company)
  end

  it 'load a company producing duplicates' do
    r = ORM::Company
      .joins(:pricing_settings)
      .where(code: company.code)

    expect(r).to include(
      have_attributes(
        code: company.code
      ),
      have_attributes(
        code: company.code
      )
    )
  end

  it 'pricing_settings are brought through `inner join`' do
    sql = ORM::Company
      .joins(:pricing_settings)
      .where(code: company.code)
      .to_sql

    expect(sql).to include(
      "FROM `companies` INNER JOIN `pricing_settings` ON `pricing_settings`.`company_code` = `companies`.`code`"
    )
  end

  it 'pricing_settings are NOT eager loaded' do
    r = ORM::Company
      .joins(:pricing_settings)
      .where(code: company.code)
      .first
    sql = r.pricing_settings.to_sql

    expect(sql).to eq("SELECT `pricing_settings`.* FROM `pricing_settings` WHERE `pricing_settings`.`company_code` = '#{company.code}'")
  end

  context 'when a company does not have pricing_settings' do
    let!(:company2) { FactoryBot.create(:company) }

    it 'the company is NOT loaded' do
      r = ORM::Company
        .joins(:pricing_settings)
        .where(code: company2.code)

      expect(r).to be_empty
    end
  end
end
