require 'spec_helper'

RSpec.describe SelectInsurancePlan, type: :interactor do
  describe '.call' do
    describe 'with score below 0' do
      let(:score) { -1 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be economic') { expect(context.plan).to eq('economic') }
    end
    describe 'with score eq 0' do
      let(:score) { 0 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be economic') { expect(context.plan).to eq('economic') }
    end
    describe 'with score eq 1' do
      let(:score) { 1 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be regular') { expect(context.plan).to eq('regular') }
    end
    describe 'with score eq 2' do
      let(:score) { 2 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be regular') { expect(context.plan).to eq('regular') }
    end
    describe 'with score eq 3' do
      let(:score) { 3 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be responsible') { expect(context.plan).to eq('responsible') }
    end
    describe 'with score above 3' do
      let(:score) { 4 }
      let(:context) { SelectInsurancePlan.call(score: score) }
      it('should plan be responsible') { expect(context.plan).to eq('responsible') }
    end
  end
end
