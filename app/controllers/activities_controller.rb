class ActivitiesController < ApplicationController
  before_action :set_activity, only: %i[ show edit update destroy ]
  helper_method :current_user

  # GET /activities or /activities.json
  def index
    if params[:commit] == "save"
      save_current_filter
      return redirect_to activities_path, notice: "Filtro salvo com sucesso."
    end
    @available_filter_fields = {
      "title" => "Título",
      "kind" => "Tipo",
      "urgency" => "Urgência",
      "user_name" => "Responsável",
      "priority" => "Prioridade"
    }

    @filter_configurations = current_user.filter_configurations.order(:name)

    @activities = ActivityFilterService.call(params, current_user)
    @activities = @activities.order(:start_date)
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

  def current_user
    @current_user ||= User.first
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params.require(:id))
  end

    # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity).permit(:title, :description, :status, :start_date, :end_date, :kind, :completed_percent, :priority, :urgency, :points, :user_name)
  end

  def save_current_filter
    FilterConfigurationCreator.call(params, current_user)
  end
end
