class V1::InsurancePlansController < ApplicationController
  def create
    @result = CalculateInsurancePlans.call(params: profile_params)
    if @result.success?
      render json: @result.plans, only: %i[auto disability home life], status: :ok
    else
      render json: { error: @result.error }, status: :bad_request
    end
  end

  private

  def profile_params
    params.permit(:age,
                  :dependents,
                  :income,
                  :marital_status,
                  risk_questions: [],
                  vehicle: [:year],
                  house: [:ownership_status])
  end
end
