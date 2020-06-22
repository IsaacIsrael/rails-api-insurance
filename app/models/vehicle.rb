class Vehicle < ApplicationRecord
  belongs_to :user

  validates_numericality_of :year,
                            greater_than_or_equal_to: 0,
                            only_integer: true
end
