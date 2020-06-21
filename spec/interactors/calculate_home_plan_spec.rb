require 'spec_helper'

RSpec.describe CalculateHomePlan, type: :interactor do
  describe '.call' do
    let(:profile) do
      house = FactoryBot.build(:house, ownership_status:'owned')
      FactoryBot.build(:user, house: house)
    end
    let(:base_score) { 2 }
    describe 'with no house' do
      before { profile.house = nil }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be ineligible') { expect(context.plans.home).to eq('ineligible') }
    end
    describe 'with house' do
      before { profile.house = FactoryBot.build(:house) }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan not be ineligible') { expect(context.plans.home).to_not eq('ineligible') }
    end
    describe 'with out deduction' do
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house score  be equal a base score') { expect(context.home_score).to eq(base_score) }
    end
    describe 'with mortgaged house ' do
      before { profile.house.ownership_status = 'mortgaged' }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should home score be added by  1 point') { expect(context.home_score).to eq(base_score + 1) }
    end
    describe 'with owned house' do
      before { profile.house.ownership_status = 'owned' }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should home score no be added by 1 point') { expect(context.home_score).to eq(base_score) }
    end
    describe 'with house score below 0' do
      let(:base_score) { -1 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be economic') { expect(context.plans.home).to eq('economic') }
    end
    describe 'with house score eq 0' do
      let(:base_score) { 0 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be economic') { expect(context.plans.home).to eq('economic') }
    end
    describe 'with house score eq 1' do
      let(:base_score) { 1 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be regular') { expect(context.plans.home).to eq('regular') }
    end
    describe 'with house score eq 2' do
      let(:base_score) { 2 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be regular') { expect(context.plans.home).to eq('regular') }
    end
    describe 'with house score eq 3' do
      let(:base_score) { 3 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be responsible') { expect(context.plans.home).to eq('responsible') }
    end
    describe 'with house score above 3' do
      let(:base_score) { 4 }
      let(:context) { CalculateHomePlan.call(profile: profile, base_score: base_score) }
      it('should house plan be responsible') { expect(context.plans.home).to eq('responsible') }
    end
  end
end
