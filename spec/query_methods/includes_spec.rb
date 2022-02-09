RSpec.describe "includes" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:pricing_settings) do
    FactoryBot.create_list(:pricing_setting, 2, company: company)
  end

  it 'load a company and its pricing_settings' do
    r = ORM::Company
      .where(code: company.code)
      .includes(:pricing_settings)

    expect(r).to include(
      have_attributes(
        code: company.code,
        pricing_settings: pricing_settings
      )
    )
  end

  it 'company pricing_settings are loaded on a separate SQL query' do
    sql = ORM::Company
      .where(code: company.code)
      .includes(:pricing_settings)
      .to_sql

    expect(sql).to eq(
      "SELECT `companies`.* FROM `companies` WHERE `companies`.`code` = '#{company.code}'")
  end

  context 'when conditions on `pricing_settings` are passed' do
    it 'switch to perform a single SQL query' do
      sql = ORM::Company
        .where(code: company.code, pricing_settings: { id: nil })
        .includes(:pricing_settings)
        .to_sql

      expect(sql).to include(
        "FROM `companies` LEFT OUTER JOIN `pricing_settings` ON `pricing_settings`.`company_code` = `companies`.`code`"
      )
    end
  end

  context 'includes and references' do
    it 'perform a single SQL query' do
      sql = ORM::Company
        .where(code: company.code)
        .includes(:pricing_settings)
        .references(:pricing_settings)
        .to_sql

      expect(sql).to include(
        "FROM `companies` LEFT OUTER JOIN `pricing_settings` ON `pricing_settings`.`company_code` = `companies`.`code`"
      )
    end
  end
end
