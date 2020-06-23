require 'rails_helper'

RSpec.describe V1::InsurancePlansController, type: :controller do
  describe '#create' do
    let(:params) do
      {
        vehicle: { year: 6.year
                          .ago
                          .beginning_of_day
                          .year },
        house: { ownership_status: 'owned' },
        risk_questions: [1, 1, true],
        income: 1000,
        dependents: 0,
        marital_status: 'single',
        age: 41
      }
    end
    context 'passing valid parameters' do
      before { post :create, params: params, as: :json }
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status :ok }
    end
    context 'passing decimal age' do
      before do
        params[:age] = 1.5
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing age lower than 0' do
      before do
        params[:age] = -1
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing decimal dependents' do
      before do
        params[:dependents] = 1.5
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing dependents lower than 0' do
      before do
        params[:dependents] = -1
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing decimal income' do
      before do
        params[:income] = 1.5
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing income lower than 0' do
      before do
        params[:income] = -1
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing marital status diferent than "single" or "married"' do
      before do
        params[:marital_status] = nil
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing income risk questions with two answers' do
      before do
        params[:risk_questions] = [1, 1]
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing income risk questions with four answers' do
      before do
        params[:risk_questions] = [1, 1, 1, 1]
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing income risk questions with not bollean' do
      before do
        params[:risk_questions] = ['1', '0', '1']
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'dont passing house' do
      before do
        params[:house] = nil
        post :create, params: params, as: :json
      end
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status :ok }
    end
    context 'passing more than one house' do
      before do
        params[:house] = [{ ownership_status: 'owned' },{ ownership_status: 'owned' }]
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing ownership status diferent than "owned" or "mortgaged"' do
      before do
        params[:house] = { ownership_status: nil }
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'dont passing vehicle' do
      before do
        params[:vehicle] = nil
        post :create, params: params, as: :json
      end
      it { expect(response).to be_successful }
      it { expect(response).to have_http_status :ok }
    end
    context 'passing more than one vehicle' do
      before do
        params[:vehicle] = [{ year: 2014},{ year: 2014}]
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing decimal vehicle year' do
      before do
        params[:vehicle] = { year: 1.5 }
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
    context 'passing vehicle year lower than 0' do
      before do
        params[:vehicle] = { year: -1 }
        post :create, params: params, as: :json
      end
      it { expect(response).to_not be_successful }
      it { expect(response).to have_http_status :bad_request }
    end
  end
end
