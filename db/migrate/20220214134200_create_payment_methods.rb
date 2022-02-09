class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods, id: :string, primary_key: :code, limit: 36 do |t|
      t.string :name, null: false
      t.integer :_type, null: false
      t.bigint :minimum_amount
      t.bigint :maximum_amount
      t.timestamps
    end
    add_index :payment_methods, :_type
  end
end
