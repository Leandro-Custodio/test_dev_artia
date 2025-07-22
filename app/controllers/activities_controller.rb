class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]

  # GET /activities or /activities.json
  def index
    @activities = Activity.all.order(:start_date)

    if params[:filters].present? && params[:group_operator].present?
      filters = params[:filters]
      group_operator = params[:group_operator] # "and" ou "or"

      group_relations = []

      filters.each_value do |group|
        group_operator_within = group["operator"] || "and"
        conditions = group["conditions"] || {}

        group_scope = nil

        conditions.each_value do |condition|
          field = condition["field"]
          value = condition["value"]

          next if field.blank? || value.blank?
          next unless Activity.column_names.include?(field)

          condition_scope = Activity.where("lower(#{field}) LIKE ?", "%#{value.downcase}%")

          group_scope = if group_scope.nil?
            condition_scope
          else
            group_operator_within == "or" ? group_scope.or(condition_scope) : group_scope.merge(condition_scope)
          end
        end

        group_relations << group_scope if group_scope.present?
      end

      if group_relations.any?
        final_scope = group_relations.shift
        group_relations.each do |scope|
          final_scope = group_operator == "or" ? final_scope.or(scope) : final_scope.merge(scope)
        end

        @activities = final_scope.order(:start_date)
      end
    end
  end

  # GET /activities/1 or /activities/1.json
  def show
  end

  # GET /activities/new
  def new
    @activity = Activity.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities or /activities.json
  def create
    @activity = Activity.new(activity_params)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @activity, notice: "Activity was successfully created." }
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1 or /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to @activity, notice: "Activity was successfully updated." }
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1 or /activities/1.json
  def destroy
    @activity.destroy!

    respond_to do |format|
      format.html { redirect_to activities_path, status: :see_other, notice: "Activity was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params.require(:id))
  end

    # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity).permit(:title, :description, :status, :start_date, :end_date, :kind, :completed_percent, :priority, :urgency, :points, :user_id)
  end
end
