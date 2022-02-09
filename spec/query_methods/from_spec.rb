RSpec.describe "from" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:company2) { FactoryBot.create(:company) }
  let!(:pricing_settings_for_company) do
    FactoryBot.create_list(:pricing_setting, 2, spread_unit_rate: 0.05, company: company)
  end
  let!(:pricing_settings_for_company2) do
    FactoryBot.create_list(:pricing_setting, 1, spread_unit_rate: 0.01, company: company2)
  end

  it 'passes the table for which the records will be fetched' do
    r = ORM::PricingSetting
      .select(:spread_unit_rate)
      .from('pricing_settings')

    expect(r.to_sql).to eq("SELECT `pricing_settings`.`spread_unit_rate` FROM pricing_settings")
  end

  context 'when the table passed is not a String' do
    it 'raises error' do
      expect do
        ORM::PricingSetting
          .select(:spread_unit_rate)
          .from(:pricing_settings)
          .to_a
      end.to raise_error(Arel::Visitors::UnsupportedVisitError, /Unsupported argument type: Symbol/)
    end
  end

  context 'when another ActiveRecord::Relation is passed' do
    it 'a `simple subquery` is performed' do
      # company codes for pricing_settings greater than 0.01
      r = ORM::PricingSetting
        .select(:company_code)
        .from(
          ORM::PricingSetting.where("spread_unit_rate > 0.01")
        )
      expect(r.to_a).to contain_exactly(
        have_attributes(company_code: company.code),
        have_attributes(company_code: company.code)
      )
    end

    it 'a `simple subquery` is performed with an alias' do
      r = ORM::PricingSetting
        .select(:"ps.company_code")
        .from(
          ORM::PricingSetting.where("spread_unit_rate > 0.01"),
          :ps
        )
      expect(r).to contain_exactly(
        have_attributes(company_code: company.code),
        have_attributes(company_code: company.code)
      )
    end
  end

  context 'when from is used within a where' do
    it 'query with `correlated subquery` is performed' do
      # Companies having pricing_settings greater than 0.01
      r = ORM::Company
        .where(
          "EXISTS (:greather_spread)",
          greather_spread: ORM::Company.select("1").from("pricing_settings").where("spread_unit_rate > 0.01").where("companies.code = pricing_settings.company_code")
        )

      expect(r). to contain_exactly(
        have_attributes(code: company.code)
      )
      expect(r.to_sql).to eq("SELECT `companies`.* FROM `companies` WHERE (EXISTS (SELECT 1 FROM pricing_settings WHERE (spread_unit_rate > 0.01) AND (companies.code = pricing_settings.company_code)))")
    end
  end
end
