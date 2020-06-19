class CalculateAutoPlan
  include Interactor

  def call
    profile = context.profile
    context.plans = context.plans || InsurancePlan.new(user: profile)

    return context.plans.auto = 'ineligible' unless profile.vehicle

    context.auto_score = context.base_score
    context.auto_score += 1 if profile.vehicle.year >= 5.year
                                                        .ago
                                                        .beginning_of_day
                                                        .year

    context.plans.auto = SelectInsurancePlan.call(score: context.auto_score)
                                            .plan
  end
end
