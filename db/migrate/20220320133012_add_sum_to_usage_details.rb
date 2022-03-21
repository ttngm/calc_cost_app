class AddSumToUsageDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :usage_details, :sum, :integer
  end
end
