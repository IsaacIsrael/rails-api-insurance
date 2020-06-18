require 'spec_helper'

RSpec.describe BuildProfile, type: :interactor do
  describe '.call' do
    let(:params) do
      user = FactoryBot.attributes_for(:user)
      user[:vehicle] = user[:vehicle_attributes]
      user[:house] = user[:house_attributes]
      user.except(:vehicle_attributes, :house_attributes)
    end
    describe 'passing a valid params ' do
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq true') { expect(context.success?).to be_truthy }
    end
    describe 'passing a negative number as age ' do
      before { params[:age] = -1 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a decimal as age ' do
      before { params[:age] = 1.5 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a negative number as dependents ' do
      before { params[:dependents] = -1 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a decimal as dependents ' do
      before { params[:dependents] = 1.5 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a negative number as income ' do
      before { params[:income] = -1 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a decimal as income ' do
      before { params[:income] = 1.5 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a number as marital status ' do
      before { params[:marital_status] = 1.5 }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a invalid option as marital status' do
      before { params[:marital_status] = 'dhjasdhs' }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a empty as marital status' do
      before { params[:marital_status] = '' }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing nil as marital status' do
      before { params[:marital_status] = nil }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a empty as risk questions' do
      before { params[:risk_questions] = [] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing nil as risk questions' do
      before { params[:risk_questions] = nil }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing invalid options(not bolleans) as risk questions' do
      before { params[:risk_questions] = [nil, 0, 1] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') {expect(context.success?).to be_falsey}
    end
    describe 'passing more than 3 questions as risk questions' do
      before { params[:risk_questions] = [0, 0, 0, 0] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing less than 3 questions as risk questions' do
      before { params[:risk_questions] = [0, 0] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a invalid option as house ownership status' do
      before { params[:house] = { ownership_status: 'dgsadhsagj' } }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a empty as house ownership status' do
      before { params[:house] = { ownership_status: '' } }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing nil as house ownership status' do
      before { params[:house] = { ownership_status: nil } }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing two houses' do
      before { params[:house] = [{ 'ownership_status': 'owned' }, { 'ownership_status': 'owned' }] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    # describe 'passing house as not a hash' do
    #   before { params[:house] = 'house' }
    #   let(:context) { BuildProfile.call(params: params) }
    #   it('should success? eq false') { expect(context.success?).to be_falsey }
    # end
    describe 'passing house as null' do
      before { params[:house] = nil }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq true') { expect(context.success?).to be_truthy }
    end
    describe 'dont passing house' do
      before { params.delete(:house) }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq true') { expect(context.success?).to be_truthy }
    end
    describe 'passing a negative number as vehicle year ' do
      before { params[:vehicle] = { year: -1 } }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing a decimal as vehicle year' do
      before { params[:vehicle] = { year: 1.5 } }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    describe 'passing two vehicle' do
      before { params[:vehicle] = [{ 'year': 2018 }, { 'year': 2018 }] }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq false') { expect(context.success?).to be_falsey }
    end
    # describe 'passing vehicle as not a hash' do
    #   before { params[:vehicle] = 'vehicle' }
    #   let(:context) { BuildProfile.call(params: params) }
    #   it('should success? eq false') { expect(context.success?).to be_falsey }
    # end
    describe 'passing vehicle as null' do
      before { params[:vehicle] = nil }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq true') { expect(context.success?).to be_truthy }
    end
    describe 'dont passing vehicle' do
      before { params.delete(:vehicle) }
      let(:context) { BuildProfile.call(params: params) }
      it('should success? eq true') { expect(context.success?).to be_truthy }
    end
  end
end
