class SelectInsurancePlan
  include Interactor

  def call
    case
    when context.score <= 0 then context.plan = 'economic'
    when context.score.between?(1, 2) then context.plan = 'regular'
    when context.score >= 3 then context.plan = 'responsible'
    end
  end
end
