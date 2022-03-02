RSpec.describe "distinct" do
  let!(:company) { FactoryBot.create(:company) }
  let!(:pricing_settings) do
    FactoryBot.create_list(:pricing_setting, 2, company: company)
  end

  it 'removes duplicates' do
    r = ORM::Company
      .joins(:pricing_settings)
      .distinct

    expect(r.size).to eq(1)
  end
    
  it 'is chainable' do
    r = ORM::Company
      .joins(:pricing_settings)
      .distinct

    expect(r).to be_a(ActiveRecord::Relation)
  end

  context 'when combined with select' do
    it 'uses selected values for the distinct clause' do
      r = ORM::Company
        .select(:code)
        .joins(:pricing_settings)
        .distinct

      expect(r.to_sql).to include("SELECT DISTINCT `companies`.`code`")
    end
  end

  context 'when receives false' do
    it 'do NOT remove duplicates' do
      r = ORM::Company
      .joins(:pricing_settings)
      .distinct(false)

      expect(r.size).to eq(2)
    end
  end
end
