require 'spec_helper'

RSpec.describe CalculateLifePlan, type: :interactor do
  describe '.call' do
    let(:profile) { FactoryBot.build(:user, dependents: 0, marital_status: 'single') }
    let(:base_score) { 3 }
    describe 'with age over 60 years old' do
      before { profile.age = 61 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be ineligible') { expect(context.plans.life).to eq('ineligible') }
    end
    describe 'with age as 60 years old' do
      before { profile.age = 60 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan not be ineligible') { expect(context.plans.life).to_not eq('ineligible') }
    end
    describe 'with age bellow 60 years old' do
      before { profile.age = 59  }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan not be ineligible') { expect(context.plans.life).to_not eq('ineligible') }
    end
    describe 'with out deduction' do
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score be equal a base score') { expect(context.life_score).to eq(base_score) }
    end
    describe 'with dependents ' do
      before { profile.dependents = 2 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score be added by 1 point') { expect(context.life_score).to eq(base_score + 1) }
    end
    describe 'with no dependents' do
      before { profile.dependents = 0 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score no be added by 1 point') { expect(context.life_score).to eq(base_score) }
    end
    describe 'with marital status as married' do
      before { profile.marital_status = 'married' }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.life_score).to eq(base_score + 1) }
    end
    describe 'with marital status as single' do
      before { profile.marital_status = 'single' }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added by 1 point') { expect(context.life_score).to eq(base_score) }
    end
    describe 'with dependents and marital status as married' do
      before do
        profile.dependents = 2
        profile.marital_status = 'married'
      end
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score be added by 2 point') { expect(context.life_score).to eq(base_score + 2) }
    end
    describe 'with dependents and marital status as single' do
      before do
        profile.dependents = 2
        profile.marital_status = 'single'
      end
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score be added by 1 point') { expect(context.life_score).to eq(base_score + 1) }
    end
    describe 'with no dependents and marital status as married' do
      before do
        profile.dependents = 0
        profile.marital_status = 'married'
      end
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score no be added by 1 point') { expect(context.life_score).to eq(base_score + 1) }
    end
    describe 'with no dependents and marital status as single' do
      before do
        profile.dependents = 0
        profile.marital_status = 'single'
      end
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life score no be added any points') { expect(context.life_score).to eq(base_score) }
    end
    describe 'with life score below 0' do
      let(:base_score) { -1 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be economic') { expect(context.plans.life).to eq('economic') }
    end
    describe 'with life score eq 0' do
      let(:base_score) { 0 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be economic') { expect(context.plans.life).to eq('economic') }
    end
    describe 'with life score eq 1' do
      let(:base_score) { 1 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be regular') { expect(context.plans.life).to eq('regular') }
    end
    describe 'with life score eq 2' do
      let(:base_score) { 2 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be regular') { expect(context.plans.life).to eq('regular') }
    end
    describe 'with life score eq 3' do
      let(:base_score) { 3 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be responsible') { expect(context.plans.life).to eq('responsible') }
    end
    describe 'with life score above 3' do
      let(:base_score) { 4 }
      let(:context) { CalculateLifePlan.call(profile: profile, base_score: base_score) }
      it('should life plan be responsible') { expect(context.plans.life).to eq('responsible') }
    end
  end
end
