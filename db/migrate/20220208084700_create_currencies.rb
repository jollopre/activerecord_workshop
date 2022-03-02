class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :currencies, id: :string, primary_key: :code, limit: 4 do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
