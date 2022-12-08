RSpec.describe ORM::UuidType, :skip_database_cleaner do
  let(:repository) do
    Class.new(ActiveRecord::Base) do
      self.table_name = 'table_with_uuid'
      self.primary_key = 'id'
      attribute :id, ORM::UuidType.new
    end
  end
  let(:id) { "9a909bf0-6569-40c5-90a1-9ea9f9509f2e" }
  let(:binary_id) { [id.delete("-")].pack("H*")}
  let(:quoted_id) { "x'#{id.delete("-")}'" }
  let(:connection) { ActiveRecord::Base.connection }
  before do
    connection.drop_table(:table_with_uuid, if_exists: true)
    connection.create_table(:table_with_uuid, id: false, if_not_exists: true) do |t|
      t.column(:id, :binary, limit: 16, if_not_exists: true)
    end
  end
  after do
    connection.drop_table(:table_with_uuid, if_exists: true)
  end

  describe '.new' do
    subject { repository.new(id: id) }

    it "sets id as string" do
      expect(subject.id).to eq(id)
    end

    context "when persisted" do
      it "serializes id as binary" do
        subject.save

        result = repository.connection.execute("select * from table_with_uuid where id = #{quoted_id} limit 1")
        expect(result.first.first).to eq(binary_id)
        expect(result.first.first.encoding).to eq(Encoding::ASCII_8BIT)
      end
    end
  end

  describe '.create' do
    it "serializes id as binary" do
      repository.create(id: id)

      result = repository.connection.execute("select * from table_with_uuid where id = #{quoted_id} limit 1")
      expect(result.first.first).to eq(binary_id)
      expect(result.first.first.encoding).to eq(Encoding::ASCII_8BIT)
    end
  end

  describe '.find' do
    it "retrieves id as uuid" do
      repository.create(id: id)

      result = repository.find(id)
      expect(result.id).to eq(id)
    end
  end
end
