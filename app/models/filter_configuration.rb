class FilterConfiguration < ApplicationRecord
  belongs_to :user
  has_many :filter_groups, dependent: :destroy

  accepts_nested_attributes_for :filter_groups, allow_destroy: true

  validates :name, presence: true
  validates :group_operator, inclusion: { in: %w[and or] }
end