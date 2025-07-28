class Activity < ApplicationRecord
  KIND_MAP = {
    1 => "Melhoria",
    2 => "Bug",
    3 => "Spike",
    4 => "Documentação",
    5 => "Reunião"
  }.freeze

  KIND_MAP_INVERTED = KIND_MAP.transform_keys(&:to_s).invert.transform_keys(&:downcase).freeze


  URGENCY_MAP = {
    1 => "Alto",
    2 => "Médio",
    3 => "Baixo"
  }.freeze

  URGENCY_MAP_INVERTED = URGENCY_MAP.transform_keys(&:to_s).invert.transform_keys(&:downcase).freeze


  belongs_to :user

  def kind_value
    KIND_MAP[self.kind]
  end

  def urgency_value
    URGENCY_MAP[self.urgency]
  end
end
