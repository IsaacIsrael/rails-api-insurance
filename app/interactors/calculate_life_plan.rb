class CalculateLifePlan
  include Interactor

  def call
    profile = context.profile
    context.plans = context.plans || InsurancePlan.new(user: profile)

    return context.plans.life = 'ineligible' if profile.age > 60

    context.life_score = context.base_score
    context.life_score += 1 unless profile.dependents.zero?
    context.life_score += 1 if profile.marital_status.eql?('married')

    context.plans.life = SelectInsurancePlan.call(score: context.life_score)
                                            .plan
  end
end
