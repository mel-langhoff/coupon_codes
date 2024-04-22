class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.references :merchant, null: false, foreign_key: true
      t.string :value_type
      t.integer :value_off
      t.boolean :active
      t.integer :usage_amount

      t.timestamps
    end
  end
end
