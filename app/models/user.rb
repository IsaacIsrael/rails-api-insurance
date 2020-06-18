class User < ApplicationRecord
  has_one :house
  validates_numericality_of :age,
                            greater_than_or_equal_to: 0,
                            only_integer: true
  validates_numericality_of :dependents,
                            greater_than_or_equal_to: 0,
                            only_integer: true
  validates_numericality_of :income,
                            greater_than_or_equal_to: 0,
                            only_integer: true

  validates :marital_status, inclusion: { in: %w(single married), message: "value is not in the list" }

  validates :risk_questions,
            length: { is: 3, message: 'is the wrong length (should be 3 answers)' }

  validate :invalid

  accepts_nested_attributes_for :house

  def initialize(attribute)
    if attribute && attribute[:risk_questions]
      validate_risk_questions attribute[:risk_questions]
    end

    super attribute
  end

  def risk_questions=(value)
    validate_risk_questions value
    super
  end

  private

  def validate_risk_questions(attribute)
    unless attribute&.all? { |answers| [1, 0, true, false].include? answers }
      @invlaid = {
        key:  :risk_questions,
        message: 'is not a array of booleans'
      }
    end
  end

  def invalid
    errors.add(@invlaid[:key], @invlaid[:message]) if @invlaid
  end
end
