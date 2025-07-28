class FilterGroup < ApplicationRecord
  belongs_to :filter_configuration
  has_many :filter_conditions, dependent: :destroy
  accepts_nested_attributes_for :filter_conditions, allow_destroy: true

  validates :position, inclusion: { in: 1..4 }
  validates :operator, inclusion: { in: %w[and or] }
end
