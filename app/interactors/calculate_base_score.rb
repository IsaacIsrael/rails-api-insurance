class CalculateBaseScore
  include Interactor

  def call
    profile = context.profile

    context.base_score = profile.risk_questions.inject(&:+)

    context.base_score -= 1 if profile.age <= 40
    context.base_score -= 1 if profile.age < 30
    context.base_score -= 1 if profile.income >= 200000
  end
end
