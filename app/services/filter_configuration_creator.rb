class FilterConfigurationCreator
  def self.call(params, user)
    new(params, user).save!
  end

  def initialize(params, user)
    @params = params
    @user = user
  end

  def save!
    return if @params[:filters].blank?

    config = @user.filter_configurations.create!(
      name: @params[:filter_name] + generate_filter_name,
      group_operator: @params[:group_operator],
      filter_groups: build_filter_groups
    )
    config
  end

  private

  def generate_filter_name
    timestamp = Time.current.strftime("%d/%m/%Y %H:%M")
    " - Filtro salvo em #{timestamp}"
  end

  def build_filter_groups
    filters_data = @params.require(:filters).permit!.to_h

    filters_data.map.with_index do |_group_id, index|
      group_data = filters_data[index.to_s]

      conditions = build_conditions(group_data["conditions"])
      next if conditions.empty?

      FilterGroup.new(
        operator: group_data["operator"],
        position: index + 1,
        filter_conditions: conditions
      )
    end.compact
  end

  def build_conditions(conditions_data)
    return [] unless conditions_data

    conditions_data.to_h.map do |_cond_id, condition|
      field = condition["field"].to_s.strip
      value = condition["value"].to_s.strip

      next if field.blank? || value.blank?

      FilterCondition.new(
        field: field,
        value: value
      )
    end.compact
  end
end
