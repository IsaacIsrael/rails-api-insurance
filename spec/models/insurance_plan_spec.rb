require 'rails_helper'

RSpec.describe InsurancePlan, type: :model do
  it { should belong_to(:user) }
end
