module ActivitiesHelper
    def display_user_name(activity)
        activity.user&.name || "Sem responsável"
    end
end
