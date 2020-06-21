class CalculateInsurancePlans
  include Interactor::Organizer

  organize BuildProfile, CalculateBaseScore, CalculateAutoPlan, CalculateDisabilityPlan, CalculateHomePlan, CalculateLifePlan
end
