RSpec.describe "group" do
  let!(:company) { FactoryBot.create(:company, sector: :Industrials) }
  let!(:company2) { FactoryBot.create(:company, sector: :InformationTechnology) }
  let!(:company3) { FactoryBot.create(:company, sector: :Industrials) }

  it 'returns a record for each different group found using `select`' do
    r = ORM::Company
      .select(:sector)
      .group(:sector)

    expect(r).to contain_exactly(
      have_attributes(sector: company.sector),
      have_attributes(sector: company2.sector),
    )
  end

  it 'returns a record for each different group found using `pluck`' do
    r = ORM::Company
      .group(:sector)
      .pluck(:sector)

    expect(r).to contain_exactly(
      company.sector,
      company2.sector
    )
  end

  it 'is chainable' do
    r = ORM::Company
      .select(:sector)
      .group(:sector)

    expect(r).to be_a(ActiveRecord::Relation)
  end

  context 'when combined with an aggregated method' do
    it 'returns group/aggregated method' do
      r = ORM::Company
        .select(:sector)
        .group(:sector)
        .count(:sector)

      expect(r).to eq(
        'Industrials' => 2,
        'InformationTechnology' => 1
      )
    end
  end

  context 'when a select method is not used together with the group' do
    it 'raise sql syntax error' do
      expect do
        ORM::Company
          .group(:sector)
          .to_a
      end.to raise_error(ActiveRecord::StatementInvalid, /SELECT list is not in GROUP BY clause/)
    end
  end
end
