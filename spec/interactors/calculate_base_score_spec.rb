require 'spec_helper'

RSpec.describe CalculateBaseScore, type: :interactor do
  describe '.call' do
    let(:profile) { FactoryBot.build(:user, risk_questions: [1, 1, 1], age: 41, income: 0) }
    describe 'with out deduction ' do
      before { profile.risk_questions = [0, 1, 1] }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be sum of the risk questions') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age under 30 years old ' do
      before { profile.age = 29 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end
    describe 'passing profile age as 30 years old' do
      before { profile.age = 40 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age between 30 and 40 years old ' do
      before { profile.age = 34 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age as 40 years old ' do
      before { profile.age = 40 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age over 40 years old ' do
      before { profile.age = 41 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 0 points') { expect(context.base_score).to eq(3) }
    end
    describe 'passing income under $200k ' do
      before { profile.income = 199999 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 0 points') { expect(context.base_score).to eq(3) }
    end
    describe 'passing income over $200k ' do
      before { profile.income = 200001 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing income as $200k ' do
      before { profile.income = 200000 }
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age under 30 years old and passing income under $200k' do
      before do
        profile.age = 29
        profile.income = 199999
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end
    describe 'passing profile age under 30 years old and passing income over $200k' do
      before do
        profile.age = 29
        profile.income = 200001
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 3 points') { expect(context.base_score).to eq(0) }
    end
    describe 'passing profile age under 30 years old and passing income as $200k' do
      before do
        profile.age = 29
        profile.income = 200000
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 3 points') { expect(context.base_score).to eq(0) }
    end

    describe 'passing profile age as 30 years old and passing income under $200k' do
      before do
        profile.age = 30
        profile.income = 199999
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age as 30 years old and passing income over $200k' do
      before do
        profile.age = 30
        profile.income = 200001
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end
    describe 'passing profile age as 30 years old  and passing income as $200k' do
      before do
        profile.age = 30
        profile.income = 200000
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end

    describe 'passing profile age between 30 and 40 years old and passing income under $200k' do
      before do
        profile.age = 35
        profile.income = 199999
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile age between 30 and 40 years old and passing income over $200k' do
      before do
        profile.age = 35
        profile.income = 200001
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end
    describe 'passing profile age between 30 and 40 years old and passing income as $200k' do
      before do
        profile.age = 35
        profile.income = 200000
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end

    describe 'passing profile as 40 years old and passing income under $200k' do
      before do
        profile.age = 40
        profile.income = 199999
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile as 40 years old and passing income over $200k' do
      before do
        profile.age = 40
        profile.income = 200001
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end
    describe 'passing profile as 40 years old and passing income as $200k' do
      before do
        profile.age = 40
        profile.income = 200000
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 2 points') { expect(context.base_score).to eq(1) }
    end

     describe 'passing profile over 40 years old and passing income under $200k' do
      before do
        profile.age = 41
        profile.income = 199999
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 0 points') { expect(context.base_score).to eq(3) }
    end
    describe 'passing profile over 40 years old and passing income over $200k' do
      before do
        profile.age = 41
        profile.income = 200001
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
    describe 'passing profile over 40 years old and passing income as $200k' do
      before do
        profile.age = 41
        profile.income = 200000
      end
      let(:context) { CalculateBaseScore.call(profile: profile) }
      it('should base score be deducted by 1 points') { expect(context.base_score).to eq(2) }
    end
  end
end
