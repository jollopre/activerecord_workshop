RSpec.describe "preload" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:pricing_settings) do
    FactoryBot.create_list(:pricing_setting, 2, company: company)
  end

  it 'load a company and its pricing_settings' do
    r = ORM::Company
      .where(code: company.code)
      .preload(:pricing_settings)

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
      .preload(:pricing_settings)
      .to_sql

    expect(sql).to eq(
      "SELECT `companies`.* FROM `companies` WHERE `companies`.`code` = '#{company.code}'")
  end

  context 'conditions on `pricing_settings`' do
    it 'raise a SQL syntax error' do
      expect do
        ORM::Company
          .where(code: company.code, pricing_settings: { id: nil })
          .preload(:pricing_settings)
          .to_a
      end.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  context 'when a relation table is not defined at the model' do
    it 'raise AssociationNotFoundError' do
      expect do
        ORM::Company
          .preload(:wadus)
          .to_a
      end.to raise_error(ActiveRecord::AssociationNotFoundError)
    end
  end
end
