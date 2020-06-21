require 'spec_helper'

RSpec.describe CalculateDisabilityPlan, type: :interactor do
  describe '.call' do
    let(:profile) do
      house = FactoryBot.build(:house, ownership_status: 'owned')
      FactoryBot.build(:user, marital_status: 'single', dependents: 0, house: house)
    end
    let(:base_score) { 3 }
    describe 'with no income' do
      before { profile.income = 0 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with income' do
      before { profile.income = 200 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan not be ineligible') { expect(context.plans.disability).to_not eq('ineligible') }
    end
    describe 'with age over 60 years old' do
      before { profile.age = 61 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with age as 60 years old' do
      before { profile.age = 60 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan not be ineligible') { expect(context.plans.disability).to_not eq('ineligible') }
    end
    describe 'with age bellow 60 years old' do
      before { profile.age = 59  }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan not be ineligible') { expect(context.plans.disability).to_not eq('ineligible') }
    end
    describe 'with age over 60 years old and no income' do
      before do
        profile.age = 61
        profile.income = 0
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with age as 60 years old and no income' do
      before do
        profile.age = 60
        profile.income = 0
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with age bellow 60 years old and no income' do
      before do
        profile.age = 59
        profile.income = 0
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with age over 60 years old and income' do
      before do
        profile.age = 61
        profile.income = 200
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'with age as 60 years old and income' do
      before do
        profile.age = 60
        profile.income = 200
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan not be ineligible') { expect(context.plans.disability).to_not eq('ineligible') }
    end
    describe 'with age bellow 60 years old and income' do
      before do
        profile.age = 59
        profile.income = 200
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan not be ineligible') { expect(context.plans.disability).to_not eq('ineligible') }
    end
    describe 'with out deduction' do
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score  be equal a base score') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with mortgaged house ' do
      before { profile.house.ownership_status = 'mortgaged' }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with owned house' do
      before { profile.house.ownership_status = 'owned' }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added by 1 point') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with dependents ' do
      before { profile.dependents = 2 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with no dependents' do
      before { profile.dependents = 0 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added by 1 point') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with marital status as married' do
      before { profile.marital_status = 'married' }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be removed by 1 point') { expect(context.disability_score).to eq(base_score - 1) }
    end
    describe 'with marital status as single' do
      before { profile.marital_status = 'single' }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be removed by 1 point') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with mortgaged house and dependents' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 2
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 2 point') { expect(context.disability_score).to eq(base_score + 2) }
    end
    describe 'with owned house and dependents' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 2
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with mortgaged house and no dependents' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 0
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with owned house and no dependents' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 0
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be no added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with mortgaged house and marital status as married' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with owned house and marital status as married' do
      before do
        profile.house.ownership_status = 'owned'
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be removed by 1 point') { expect(context.disability_score).to eq(base_score - 1) }
    end
    describe 'with mortgaged house and marital status as single' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.marital_status = 'sinlge'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with owned house and marital status as sinlge' do
      before do
        profile.house.ownership_status = 'owned'
        profile.marital_status = 'sinlge'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with dependents and marital status as married' do
      before do
        profile.dependents = 2
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with no dependents and marital status as married' do
      before do
        profile.dependents = 0
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be removed by 1 point') { expect(context.disability_score).to eq(base_score - 1) }
    end
    describe 'with dependents and marital status as single' do
      before do
        profile.dependents = 2
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with no dependents and marital status as married' do
      before do
        profile.dependents = 0
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with mortgaged house, dependents and marital status as married' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 2
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with mortgaged house, dependents and marital status as single' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 2
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 2 point') { expect(context.disability_score).to eq(base_score + 2) }
    end
    describe 'with mortgaged house, no dependents and marital status as married' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 0
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with mortgaged house, no dependents and marital status as single' do
      before do
        profile.house.ownership_status = 'mortgaged'
        profile.dependents = 0
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with owned house, dependents and marital status as married' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 2
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with owned house, dependents and marital status as single' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 2
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be added by 1 point') { expect(context.disability_score).to eq(base_score + 1) }
    end
    describe 'with owned house, no dependents and marital status as married' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 0
        profile.marital_status = 'married'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score be removed by 1 point') { expect(context.disability_score).to eq(base_score - 1) }
    end
    describe 'with owned house, no dependents and marital status as single' do
      before do
        profile.house.ownership_status = 'owned'
        profile.dependents = 0
        profile.marital_status = 'single'
      end
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability score no be added or removed') { expect(context.disability_score).to eq(base_score) }
    end
    describe 'with disability score below 0' do
      let(:base_score) { -1 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be economic') { expect(context.plans.disability).to eq('economic') }
    end
    describe 'with disability score eq 0' do
      let(:base_score) { 0 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be economic') { expect(context.plans.disability).to eq('economic') }
    end
    describe 'with disability score eq 1' do
      let(:base_score) { 1 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be regular') { expect(context.plans.disability).to eq('regular') }
    end
    describe 'with disability score eq 2' do
      let(:base_score) { 2 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be regular') { expect(context.plans.disability).to eq('regular') }
    end
    describe 'with disability score eq 3' do
      let(:base_score) { 3 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be responsible') { expect(context.plans.disability).to eq('responsible') }
    end
    describe 'with disability score above 3' do
      let(:base_score) { 4 }
      let(:context) { CalculateDisabilityPlan.call(profile: profile, base_score: base_score) }
      it('should disability plan be responsible') { expect(context.plans.disability).to eq('responsible') }
    end
  end
end
