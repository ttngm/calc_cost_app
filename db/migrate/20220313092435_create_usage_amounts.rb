class CreateUsageAmounts < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_amounts do |t|
      t.string :usageDate
      t.string :usageStore
      t.integer :amount
      t.integer :method
      t.references :usage_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
