require 'descriptive_statistics'
require 'securerandom'
require 'benchmark'
require_relative '../config/initializers/active_record'
require_relative '../orm/uuid_type'

module Experiments
  class BinaryUuid
    TABLE_NAME = "binary_uuids"
    TableInfo = Struct.new(:data_length, :index_length, :rows)

    class Repository < ActiveRecord::Base
      self.table_name = TABLE_NAME
      self.primary_key = 'id'
      attribute :id, ORM::UuidType.new
      serialize :data, JSON
    end

    def initialize
      @insert_time = []
      @select_time = []
    end

    def call
      setup
      (1..40000).each do |i|
        uuids = (1..25).map { SecureRandom.uuid }
        insert(uuids)
        select(uuids.sample)
        sleep(0.01)
      end
      report
      tear_down
    end

    private

    def setup
      tear_down
      connection.create_table(TABLE_NAME, id: false, if_not_exists: true) do |t|
        t.column(:id, :binary, limit: 16, null: false, if_not_exists: true)
        t.column(:data, :text, null: false, if_not_exists: true)
        t.index(:id, unique: true, if_not_exists: true)
      end
    end

    def tear_down
      connection.drop_table(TABLE_NAME, if_exists: true)
    end

    def report
      result = {
        inserts: {
          total: @insert_time.number,
          median: @insert_time.median,
          percentile_50: @insert_time.percentile(50),
          percentile_75: @insert_time.percentile(75),
          percentile_90: @insert_time.percentile(90),
          percentile_99: @insert_time.percentile(99),
        },
        selects: {
          total: @select_time.number,
          median: @select_time.median,
          percentile_50: @select_time.percentile(50),
          percentile_75: @select_time.percentile(75),
          percentile_90: @select_time.percentile(90),
          percentile_99: @select_time.percentile(99),
        },
        table: {
          name: TABLE_NAME,
          data_length: "#{table_info.data_length} (B)",
          index_length: "#{table_info.index_length} (B)",
          rows: table_info.rows
        }
      }
      pp result.to_json
    end

    def connection
      ActiveRecord::Base.connection
    end

    def insert(uuids)
      bm = Benchmark.realtime do
        collection_attrs = uuids.map do |uuid|
          { id: uuid, data: { ojete: "moreno" }}
        end
        Repository.insert_all(collection_attrs)
      end
      @insert_time << bm
    end

    def select(uuid)
      bm = Benchmark.realtime do
        Repository.find(uuid)
      end
      @select_time << bm
    end

    def table_info
      @table_info ||= connection.execute("select data_length, index_length, table_rows from information_schema.tables where table_name = '#{TABLE_NAME}';").first
      TableInfo.new(@table_info[0], @table_info[1], @table_info[2])
    end
  end
end

lambda do
  binary_uuid = Experiments::BinaryUuid.new
  binary_uuid.call
end.call
