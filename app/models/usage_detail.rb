class UsageDetail < ApplicationRecord
    has_many :usageAmounts, dependent: :destroy
end
