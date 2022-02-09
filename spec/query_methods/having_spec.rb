RSpec.describe "having" do
  let!(:company) { FactoryBot.create(:company, sector: :Industrials) }
  let!(:company2) { FactoryBot.create(:company, sector: :InformationTechnology) }
  let!(:company3) { FactoryBot.create(:company, sector: :Industrials) }

  it 'return a record for each different group meeting the condition using `select`' do
    r = ORM::Company
      .select(:sector)
      .group(:sector)
      .having("count(sector) > :amount", amount: 1)

    expect(r).to contain_exactly(
      have_attributes(sector: company.sector)
    )
  end

  it 'return a record for each different group meeting the condition using `pluck`' do
    r = ORM::Company
      .group(:sector)
      .having("count(sector) > 1")
      .pluck(:sector)

    expect(r).to eq([company.sector])
  end

  it 'is chainable' do
    r = ORM::Company
      .select(:sector)
      .group(:sector)
      .having("count(sector) > 1")

    expect(r).to be_a(ActiveRecord::Relation)
  end

  context 'when multiple conditions are passed' do
    it 'chain these conditions' do
      r = ORM::Company
        .select(:sector, :currency_code)
        .group(:sector, :currency_code)
        .having("count(sector) > 1")
        .having("count(currency_code) > 1")
      
      expect(r.to_sql).to eq("SELECT `companies`.`sector`, `companies`.`currency_code` FROM `companies` GROUP BY `companies`.`sector`, `companies`.`currency_code` HAVING (count(sector) > 1) AND (count(currency_code) > 1)")
    end
  end
end
