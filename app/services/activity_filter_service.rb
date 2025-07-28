class ActivityFilterService
  def initialize(params:, current_user:)
    @params = params
    @current_user = current_user
  end

   def self.call(params, user)
    if params[:filter_configuration_id].present?
      config = user.filter_configurations.includes(filter_groups: :filter_conditions).find(params[:filter_configuration_id])
      ActivitySpecifications.build_from_config(config)
    elsif params[:filters].present? && params[:group_operator].present?
      ActivitySpecifications.build_from_params(params[:filters], params[:group_operator])
    else
      Activity.all
    end
  end

  def filtered_activities
    return Activity.none unless filters_present?

    scope = if using_filter_config?
              apply_saved_filter
            else
              apply_custom_filter
            end

    scope.distinct
  end

  private

  def filters_present?
    @params[:filters].present? || @params[:filter_config_id].present?
  end

  def using_filter_config?
    @params[:filter_config_id].present?
  end

  def apply_saved_filter
    config = @current_user.filter_configurations.find_by(id: @params[:filter_config_id])
    return Activity.none unless config

    ActivitySpecifications.build_from_config(config)
  end

  def apply_custom_filter
    filters = @params[:filters] || {}
    operator = @params[:group_operator] || "and"
    ActivitySpecifications.build_from_params(filters, operator)
  end
end
