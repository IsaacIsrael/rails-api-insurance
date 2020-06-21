class CalculateHomePlan
  include Interactor

  def call
    profile = context.profile
    context.plans = context.plans || InsurancePlan.new(user: profile)

    return context.plans.home = 'ineligible' unless context.profile.house

    context.home_score = context.base_score
    context.home_score += 1 if profile.house.ownership_status.eql?('mortgaged')

    context.plans.home = SelectInsurancePlan.call(score: context.home_score)
                                            .plan
  end
end
