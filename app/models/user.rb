class User < ApplicationRecord
  has_many :filter_configurations, dependent: :destroy
  has_many :activities, dependent: :destroy
end