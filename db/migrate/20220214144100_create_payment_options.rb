class CreatePaymentOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_options do |t|
      t.string :currency_code, limit: 4, null: false
      t.string :payment_method_code, limit: 36, null: false
      t.timestamps
    end
    add_foreign_key :payment_options, :payment_methods, column: :payment_method_code, primary_key: :code
    add_foreign_key :payment_options, :currencies, column: :currency_code, primary_key: :code
  end
end
