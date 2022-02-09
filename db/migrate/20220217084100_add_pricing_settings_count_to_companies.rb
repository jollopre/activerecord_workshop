class AddPricingSettingsCountToCompanies < ActiveRecord::Migration[7.0]
  def change
    add_column :companies, :pricing_settings_count, :int, default: 0, null: false
  end
end
