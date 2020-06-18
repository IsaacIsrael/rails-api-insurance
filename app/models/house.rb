class House < ApplicationRecord
  belongs_to :user

  validates :ownership_status, inclusion: { in: %w(owned mortgaged), message: "value is not in the list" }
end
