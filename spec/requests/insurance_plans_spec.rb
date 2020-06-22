require 'rails_helper'

RSpec.describe "InsurancePlans", type: :request do
  describe "POST /v1_insurance_plans" do
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
      before { post  v1_insurance_plans_path, params: params, as: :json }
      it { expect(response).to have_http_status :ok }
      it { expect(JSON.parse(response.body)).to have_key('auto') }
      it { expect(JSON.parse(response.body)).to have_key('disability') }
      it { expect(JSON.parse(response.body)).to have_key('home') }
      it { expect(JSON.parse(response.body)).to have_key('life') }
    end
    context 'passing decimal age' do
      before do
        params[:age] = 1.5
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be an integer"') { expect(JSON.parse(response.body)['error']['age'][0]).to eq('must be an integer') }
    end
    context 'passing age lower than 0' do
      before do
        params[:age] = -1
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be greater than or equal to 0"') { expect(JSON.parse(response.body)['error']['age'][0]).to eq('must be greater than or equal to 0') }
    end
    context 'passing decimal dependents' do
      before do
        params[:dependents] = 1.5
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be an integer"') { expect(JSON.parse(response.body)['error']['dependents'][0]).to eq('must be an integer') }
    end
    context 'passing dependents lower than 0' do
      before do
        params[:dependents] = -1
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be greater than or equal to 0"') { expect(JSON.parse(response.body)['error']['dependents'][0]).to eq('must be greater than or equal to 0') }
    end
    context 'passing decimal income' do
      before do
        params[:income] = 1.5
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be an integer"') { expect(JSON.parse(response.body)['error']['income'][0]).to eq('must be an integer') }
    end
    context 'passing income lower than 0' do
      before do
        params[:income] = -1
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be greater than or equal to 0"') { expect(JSON.parse(response.body)['error']['income'][0]).to eq('must be greater than or equal to 0') }
    end
    context 'passing marital status diferent than "single" or "married"' do
      before do
        params[:marital_status] = nil
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "value is not in the list"') { expect(JSON.parse(response.body)['error']['marital_status'][0]).to eq('value is not in the list') }
    end
    context 'passing income risk questions with two answers' do
      before do
        params[:risk_questions] = [1, 1]
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "is the wrong length (should be 3 answers)"') { expect(JSON.parse(response.body)['error']['risk_questions'][0]).to eq('is the wrong length (should be 3 answers)') }
    end
    context 'passing income risk questions with four answers' do
      before do
        params[:risk_questions] = [1, 1, 1, 1]
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "is the wrong length (should be 3 answers)"') { expect(JSON.parse(response.body)['error']['risk_questions'][0]).to eq('is the wrong length (should be 3 answers)') }
    end
    context 'passing income risk questions with not bollean' do
      before do
        params[:risk_questions] = ['1', '0', '1']
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "is not a array of booleans"') { expect(JSON.parse(response.body)['error']['risk_questions'][0]).to eq('is not a array of booleans') }
    end
    context 'dont passing house' do
      before do
        params[:house] = nil
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it { expect(JSON.parse(response.body)).to have_key('auto') }
      it { expect(JSON.parse(response.body)).to have_key('disability') }
      it { expect(JSON.parse(response.body)).to have_key('home') }
      it { expect(JSON.parse(response.body)).to have_key('life') }
    end
    context 'passing more than one house' do
      before do
        params[:house] = [{ ownership_status: 'owned' },{ ownership_status: 'owned' }]
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "it alowed only one house"') { expect(JSON.parse(response.body)['error']['house'][0]).to eq('it alowed only one house') }
    end
    context 'passing ownership status diferent than "owned" or "mortgaged"' do
      before do
        params[:house] = { ownership_status: nil }
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "value is not in the list"') { expect(JSON.parse(response.body)['error']['house.ownership_status'][0]).to eq('value is not in the list') }
    end
    context 'dont passing vehicle' do
      before do
        params[:vehicle] = nil
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it { expect(JSON.parse(response.body)).to have_key('auto') }
      it { expect(JSON.parse(response.body)).to have_key('disability') }
      it { expect(JSON.parse(response.body)).to have_key('home') }
      it { expect(JSON.parse(response.body)).to have_key('life') }
    end
    context 'passing more than one vehicle' do
      before do
        params[:vehicle] = [{ year: 2014},{ year: 2014}]
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "it alowed only one vehicle"') { expect(JSON.parse(response.body)['error']['vehicle'][0]).to eq('it alowed only one vehicle') }
    end
    context 'passing decimal vehicle year' do
      before do
        params[:vehicle] = { year: 1.5 }
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be an integer"') { expect(JSON.parse(response.body)['error']['vehicle.year'][0]).to eq('must be an integer') }
    end
    context 'passing vehicle year lower than 0' do
      before do
        params[:vehicle] = { year: -1 }
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :bad_request }
      it { expect(JSON.parse(response.body)).to have_key('error') }
      it('error message should eq "must be greater than or equal to 0"') { expect(JSON.parse(response.body)['error']['vehicle.year'][0]).to eq('must be greater than or equal to 0') }
    end
    describe 'if the user doesn’t have income' do
      before do
        params[:income] = 0
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should disability plan be ineligible') { expect(JSON.parse(response.body)['disability']).to eq('ineligible') }
    end
    describe 'if the user doesn’t have vehicle' do
      before do
        params[:vehicle] = nil
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should auto plan be ineligible') { expect(JSON.parse(response.body)['auto']).to eq('ineligible') }
    end
    describe 'if the user doesn’t have home' do
      before do
        params[:house] = nil
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should home plan be ineligible') { expect(JSON.parse(response.body)['home']).to eq('ineligible') }
    end
    describe 'if the user is over 60 years old' do
      before do
        params[:income] = 100
        params[:age] = 61
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should disability plan be ineligible') { expect(JSON.parse(response.body)['disability']).to eq('ineligible') }
      it('should life plan be ineligible') { expect(JSON.parse(response.body)['life']).to eq('ineligible') }
    end
    describe 'with auto score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should auto plan be economic') { expect(JSON.parse(response.body)['auto']).to eq('economic') }
    end
    describe 'with auto score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should auto plan be regular') { expect(JSON.parse(response.body)['auto']).to eq('regular') }
    end
    describe 'with auto score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should auto plan be responsible') { expect(JSON.parse(response.body)['auto']).to eq('responsible') }
    end

    describe 'with disability score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should disability plan be economic') { expect(JSON.parse(response.body)['disability']).to eq('economic') }
    end
    describe 'with disability score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should disability plan be regular') { expect(JSON.parse(response.body)['disability']).to eq('regular') }
    end
    describe 'with disability score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should disability plan be responsible') { expect(JSON.parse(response.body)['disability']).to eq('responsible') }
    end

    describe 'with home score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should home plan be economic') { expect(JSON.parse(response.body)['home']).to eq('economic') }
    end
    describe 'with home score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should home plan be regular') { expect(JSON.parse(response.body)['home']).to eq('regular') }
    end
    describe 'with home score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should home plan be responsible') { expect(JSON.parse(response.body)['home']).to eq('responsible') }
    end

    describe 'with life score being 0 and below ' do
      before do
        params[:income] = 200001
        params[:age] = 29
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should life plan be economic') { expect(JSON.parse(response.body)['life']).to eq('economic') }
    end
    describe 'with life score being 1 and 2 ' do
      before do
        params[:income] = 200001
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should life plan be regular') { expect(JSON.parse(response.body)['life']).to eq('regular') }
    end
    describe 'with life score being 3 and above ' do
      before do
        params[:income] = 2000
        params[:age] = 41
        post v1_insurance_plans_path, params: params, as: :json
      end
      it { expect(response).to have_http_status :ok }
      it('should life plan be responsible') { expect(JSON.parse(response.body)['life']).to eq('responsible') }
    end
  end
end
