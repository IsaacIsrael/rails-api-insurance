require 'spec_helper'

RSpec.describe CalculateAutoPlan, type: :interactor do
  describe '.call' do
    let(:profile) do
      vehicle = FactoryBot.build(:vehicle, year: 6.year
                                                  .ago
                                                  .beginning_of_day
                                                  .year)
      FactoryBot.build(:user, vehicle: vehicle)
    end
    let(:base_score) { 3 }
    describe 'with no  vehicle' do
      before { profile.vehicle = nil }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be ineligible') { expect(context.plans.auto).to eq('ineligible') }
    end
    describe 'with  vehicle' do
      before { profile.vehicle = FactoryBot.build(:vehicle) }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan not be ineligible') { expect(context.plans.auto).to_not eq('ineligible') }
    end
    describe 'with out deduction' do
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto score be equal a base score') { expect(context.auto_score).to eq(base_score) }
    end
    describe 'with vehicle produced less than 5 years' do
      before { profile.vehicle.year = 4.year.ago.beginning_of_day .year }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto score be added by 1 point') { expect(context.auto_score).to eq(base_score + 1) }
    end
    describe 'with vehicle produced in the last 5 years' do
      before { profile.vehicle.year = 5.year.ago.beginning_of_day .year }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto score be added by 1 point') { expect(context.auto_score).to eq(base_score + 1) }
    end
    describe 'with vehicle produced more than 5 years' do
      before { profile.vehicle.year = 6.year.ago.beginning_of_day .year }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto score not be added by 1 point') { expect(context.auto_score).to eq(base_score) }
    end
    describe 'with auto score below 0' do
      let(:base_score) { -1 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be economic') { expect(context.plans.auto).to eq('economic') }
    end
    describe 'with auto score eq 0' do
      let(:base_score) { 0 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be economic') { expect(context.plans.auto).to eq('economic') }
    end
    describe 'with auto score eq 1' do
      let(:base_score) { 1 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be regular') { expect(context.plans.auto).to eq('regular') }
    end
    describe 'with auto score eq 2' do
      let(:base_score) { 2 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be regular') { expect(context.plans.auto).to eq('regular') }
    end
    describe 'with auto score eq 3' do
      let(:base_score) { 3 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be responsible') { expect(context.plans.auto).to eq('responsible') }
    end
    describe 'with auto score above 3' do
      let(:base_score) { 4 }
      let(:context) { CalculateAutoPlan.call(profile: profile, base_score: base_score) }
      it('should auto plan be responsible') { expect(context.plans.auto).to eq('responsible') }
    end
  end
end
