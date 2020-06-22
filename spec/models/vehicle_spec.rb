require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it { should belong_to(:user) }
  it { should validate_numericality_of(:year).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:year).only_integer }
end
