class CalculateDisabilityPlan
  include Interactor

  def call
    profile = context.profile
    context.plans = context.plans || InsurancePlan.new(user: profile)

    if profile.income.zero? || profile.age > 60
      return context.plans.disability = 'ineligible'
    end


    context.disability_score = context.base_score
    context.disability_score += 1 if profile.house&.ownership_status.eql?('mortgaged')
    context.disability_score += 1 unless profile.dependents.zero?
    context.disability_score -= 1 if profile.marital_status.eql?('married')

    context.plans.disability = SelectInsurancePlan.call(score: context.disability_score)
                                                  .plan
  end
end
