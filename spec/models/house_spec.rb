require 'rails_helper'

RSpec.describe House, type: :model do
  it { should belong_to(:user) }
  it { should validate_inclusion_of(:ownership_status).in_array( %w(owned mortgaged)).with_message('value is not in the list') }
end
