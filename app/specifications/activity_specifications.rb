class ActivitySpecifications
  def self.build_from_params(filters, group_operator)
    filters = filters.to_unsafe_h if filters.is_a?(ActionController::Parameters)

    groups = filters.map do |_key, group|
      build_group_scope(group["conditions"], group["operator"])
    end.compact

    if group_operator == "or" && groups.any?
      all_joins = groups.flat_map(&:joins_values).uniq
      groups.map! do |group_scope|
        missing_joins = all_joins - group_scope.joins_values
        missing_joins.reduce(group_scope) { |scope, join| scope.joins(join) }
      end
    end

    groups.reduce do |combined_scope, group_scope|
      group_operator == "and" ? combined_scope.merge(group_scope) : combined_scope.or(group_scope)
    end
  end

  def self.build_from_config(filter_config)
    groups = filter_config.filter_groups.map do |group|
      conditions = group.filter_conditions.map do |condition|
        build_condition_scope(condition.field, condition.value)
      end

      combine_groups(conditions.compact, group.operator)
    end

    combine_groups(groups.compact, filter_config.group_operator || "and")
  end

  def self.build_condition_scope(field, value)
    return nil if field.blank? || value.blank?

    sanitized_value = ActiveRecord::Base.sanitize_sql_like(value.downcase)

    case field
    when "user_name"
      Activity.joins(:user).where("LOWER(users.name) LIKE ?", "%#{sanitized_value}%")
    when "kind"
      kind_key = Activity::KIND_MAP.invert[value.capitalize] || value
      return nil unless kind_key
      Activity.where(kind: kind_key)
    when "urgency"
      urgency_key = Activity::URGENCY_MAP.invert[value.capitalize] || value
      return nil unless urgency_key
      Activity.where(urgency: urgency_key)
    else
      if Activity.column_names.include?(field)
        Activity.where("LOWER(#{field}) LIKE ?", "%#{sanitized_value}%")
      else
        nil
      end
    end
  end

  def self.build_group_scope(conditions, operator)
    needs_user_join = conditions.values.any? { |cond| cond["field"] == "user_name" }

    group_scope = nil
    conditions.values.each do |cond|
      scope = build_condition_scope(cond["field"], cond["value"])
      next if scope.nil?

      scope = scope.joins(:user) if needs_user_join && !scope.joins_values.include?(:user)

      group_scope = group_scope.nil? ? scope : merge_scopes(group_scope, scope, operator)
    end
    group_scope
  end

  def self.merge_scopes(scope1, scope2, operator)
    operator == "or" ? scope1.or(scope2) : scope1.merge(scope2)
  end

  def self.combine_groups(groups, operator)
    return Activity.none if groups.blank?

    if operator == "or"
      all_joins = groups.flat_map(&:joins_values).uniq

      groups = groups.map do |scope|
        missing_joins = all_joins - scope.joins_values
        missing_joins.reduce(scope) { |s, join| s.joins(join) }
      end
    end

    final_scope = groups.shift
    groups.each do |group|
      final_scope = merge_scopes(final_scope, group, operator)
    end
    final_scope
  end
end