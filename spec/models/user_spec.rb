require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_numericality_of(:age).only_integer }
  it { should validate_numericality_of(:age).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:dependents).only_integer }
  it { should validate_numericality_of(:dependents).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:income).only_integer }
  it { should validate_numericality_of(:income).is_greater_than_or_equal_to(0) }
  # it { should define_enum_for(:marital_status).with_values( %w(single married)) }
  it { should validate_inclusion_of(:marital_status).in_array( %w(single married)).with_message('value is not in the list') }

  it 'should validate that the length of :risk_questions is 3' do
    expect(FactoryBot.build(:user, risk_questions: [0, 0])).to_not be_valid
    expect(FactoryBot.build(:user, risk_questions: [0, 0, 0])).to be_valid
    expect(FactoryBot.build(:user, risk_questions: [0, 0, 0, 0])).to_not be_valid
  end

  it 'should validate that the :risk_questions is a array of booleans' do
    expect(FactoryBot.build(:user, risk_questions: [0, 2, 0])).to_not be_valid
    expect(FactoryBot.build(:user, risk_questions: [0, 0, nil])).to_not be_valid
    expect(FactoryBot.build(:user, risk_questions: [0, 0, 'dshdjsh'])).to_not be_valid
    expect(FactoryBot.build(:user, risk_questions: [0, 0, 0])).to be_valid
    expect(FactoryBot.build(:user, risk_questions: [1, 1, 1])).to be_valid
    expect(FactoryBot.build(:user, risk_questions: ['dsdhsk', 'dsakdj', 'adhsjdhs'])).to_not be_valid
    expect(FactoryBot.build(:user, risk_questions: [1, false, 1])).to be_valid
    expect(FactoryBot.build(:user, risk_questions: [1, true, 1])).to be_valid
  end
  it { should have_one(:house) }
  it { should accept_nested_attributes_for(:house) }
  it { should have_one(:vehicle) }
  it { should accept_nested_attributes_for(:vehicle) }
end
