class CreateUsageDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :usage_details do |t|
      t.string :year
      t.string :month

      t.timestamps
    end
  end
end
