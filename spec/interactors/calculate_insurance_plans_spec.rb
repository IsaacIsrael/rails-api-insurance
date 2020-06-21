require 'spec_helper'

RSpec.describe CalculateInsurancePlans, type: :interactor do
  describe '.call' do
    let(:params) do
      {
        vehicle: { year: 6.year
                          .ago
                          .beginning_of_day
                          .year },
        house: { ownership_status: 'owned' },
        risk_questions: [1, 1, 1],
        income: 1000,
        dependents: 0,
        marital_status: 'single',
        age: 41
      }
    end
    describe 'it calculates the base score' do
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should be the sum of the risk questions') { expect(context.base_score).to eq(3) }
    end
    describe 'if the user doesn’t have income' do
      before { params[:income] = 0 }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
    end
    describe 'if the user doesn’t have vehicle' do
      before { params[:vehicle] = nil }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto plan be ineligible') { expect(context.plans.auto).to eq('ineligible') }
    end
    describe 'if the user doesn’t have house' do
      before { params[:house] = nil }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto home be ineligible') { expect(context.plans.home).to eq('ineligible') }
    end
    describe 'if the user is over 60 years old' do
      before do
        params[:income] = 100
        params[:age] = 61
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should disability plan be ineligible') { expect(context.plans.disability).to eq('ineligible') }
      it('should life plan be ineligible') { expect(context.plans.life).to eq('ineligible') }
    end
    describe 'if the user is under 30 years' do
      before { params[:age] = 29 }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score be deduct 2 risk points') { expect(context.auto_score).to eq(1) }
      it('should disability score be deduct 2 risk points') { expect(context.disability_score).to eq(1) }
      it('should home score be deduct 2 risk points') { expect(context.home_score).to eq(1) }
      it('should life score be deduct 2 risk points') { expect(context.life_score).to eq(1) }
    end
    describe 'if the user is between 30 and 40 years old' do
      before { params[:age] =  35 }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score be deduct 1 risk points') { expect(context.auto_score).to eq(2) }
      it('should disability score be deduct 1 risk points') { expect(context.disability_score).to eq(2) }
      it('should home score be deduct 1 risk points') { expect(context.home_score).to eq(2) }
      it('should life score be deduct 1 risk points') { expect(context.life_score).to eq(2) }
    end
    describe 'if the user income is above $200k' do
      before { params[:income] = 200005 }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score be deduct 1 risk points') { expect(context.auto_score).to eq(2) }
      it('should disability score be deduct 1 risk points') { expect(context.disability_score).to eq(2) }
      it('should home score be deduct 1 risk points') { expect(context.home_score).to eq(2) }
      it('should life score be deduct 1 risk points') { expect(context.life_score).to eq(2) }
    end
    describe "if the user's house is mortgaged" do
      before { params[:house] = { ownership_status: 'mortgaged' } }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score not be change') { expect(context.auto_score).to eq(3) }
      it('should disability score be add 1 risk points') { expect(context.disability_score).to eq(4) }
      it('should home score be add 1 risk points') { expect(context.home_score).to eq(4) }
      it('should life score not be change') { expect(context.life_score).to eq(3) }
    end
    describe 'if the user has dependents' do
      before { params[:dependents] = 1 }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score not be change') { expect(context.auto_score).to eq(3) }
      it('should disability score be add 1 risk points') { expect(context.disability_score).to eq(4) }
      it('should home score not be change') { expect(context.home_score).to eq(3) }
      it('should life score be add 1 risk points') { expect(context.life_score).to eq(4) }
    end
    describe 'if the user is married' do
      before { params[:marital_status] = 'married' }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score not be change') { expect(context.auto_score).to eq(3) }
      it('should disability score be remove 1 risk points') { expect(context.disability_score).to eq(2) }
      it('should home score not be change') { expect(context.home_score).to eq(3) }
      it('should life score be add 1 risk points') { expect(context.life_score).to eq(4) }
    end
    describe "if the user's vehicle was produced in the last 5 years" do
      before { params[:vehicle] = { year: 1.year
                                           .ago
                                           .beginning_of_day
                                           .year }
             }
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto score be add 1 risk points') { expect(context.auto_score).to eq(4) }
      it('should disability not be change') { expect(context.disability_score).to eq(3) }
      it('should home score not be change') { expect(context.home_score).to eq(3) }
      it('should life score not be change') { expect(context.life_score).to eq(3) }
    end
    describe 'with auto score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto plan be economic') { expect(context.plans.auto).to eq('economic') }
    end
    describe 'with auto score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto plan be regular') { expect(context.plans.auto).to eq('regular') }
    end
    describe 'with auto score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should auto plan be responsible') { expect(context.plans.auto).to eq('responsible') }
    end
    describe 'with disability score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should disability plan be economic') { expect(context.plans.disability).to eq('economic') }
    end
    describe 'with disability score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should disability plan be regular') { expect(context.plans.disability).to eq('regular')}
    end
    describe 'with disability score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should disability plan be responsible') { expect(context.plans.disability).to eq('responsible') }
    end
    describe 'with home score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should home plan be economic') { expect(context.plans.home).to eq('economic') }
    end
    describe 'with home score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should home plan be regular') { expect(context.plans.home).to eq('regular')}
    end
    describe 'with home score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should home plan be responsible') { expect(context.plans.home).to eq('responsible') }
    end
    describe 'with life score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should life plan be economic') { expect(context.plans.life).to eq('economic') }
    end
    describe 'with life score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should life plan be regular') { expect(context.plans.life).to eq('regular')}
    end
    describe 'with life score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
      end
      let(:context) { CalculateInsurancePlans.call(params: params) }
      it('should life plan be responsible') { expect(context.plans.life).to eq('responsible') }
    end
  end
end
