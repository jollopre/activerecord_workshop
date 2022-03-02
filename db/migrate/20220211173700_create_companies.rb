class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies, id: :string, primary_key: :code, limit: 8 do |t|
      t.string :name, null: false
      t.integer :sector, null: false
      t.string :currency_code, limit: 4, null: false
      t.timestamps
    end
    add_foreign_key :companies, :currencies, column: :currency_code, primary_key: :code
  end
end
