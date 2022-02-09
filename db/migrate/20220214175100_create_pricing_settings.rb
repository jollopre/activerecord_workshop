class CreatePricingSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :pricing_settings do |t|
      t.string :company_code, limit: 8, null: false
      t.string :country_code, limit: 4, null: false
      t.decimal :spread_unit_rate, precision: 6, scale: 5, null: false
      t.json :fee, null: false
      t.belongs_to :payment_option, foreign_key: true, null: false
      t.timestamps
    end
    add_foreign_key :pricing_settings, :countries, column: :country_code, primary_key: :code
    add_foreign_key :pricing_settings, :companies, column: :company_code, primary_key: :code
  end
end
