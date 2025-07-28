class FilterCondition < ApplicationRecord
  belongs_to :filter_group

  VALID_OPERATORS = ['=', '!=', 'like'].freeze

  
  validates :field, presence: true, inclusion: { in: %w[title kind urgency user_id priority user_name] }
  validates :value, presence: true
  validates :operator, inclusion: { in: VALID_OPERATORS }, allow_nil: true
end