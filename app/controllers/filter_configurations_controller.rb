class FilterConfigurationsController < ApplicationController
  before_action :set_filter_configuration, only: %i[ show edit update destroy ]

  def index
    @filter_configurations = current_user.filter_configurations.order(:name)
  end

  def show
  end

  def new
    @filter_configuration = current_user.filter_configurations.build

    4.times do |i|
      group = @filter_configuration.filter_groups.build(position: i + 1, operator: 'and')
      4.times do |j|
        group.filter_conditions.build(position: j + 1, operator: 'and')
      end
    end
  end

  def create
    @filter_configuration = current_user.filter_configurations.build(filter_configuration_params)

    if @filter_configuration.save
      redirect_to activities_path(filter_configuration_id: @filter_configuration.id), notice: "Filtro salvo com sucesso."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @filter_configuration.update(filter_configuration_params)
      redirect_to activities_path(filter_configuration_id: @filter_configuration.id), notice: "Filtro atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @filter_configuration.destroy
    redirect_to activities_path, notice: "Filtro removido com sucesso."
  end

  def current_user
    @current_user ||= User.first
  end

  private

  def set_filter_configuration
    @filter_configuration = current_user.filter_configurations.find(params[:id])
  end

  def filter_configuration_params
    params.require(:filter_configuration).permit(
      :name,
      filter_groups_attributes: [
        :id, :operator, :position, :_destroy,
        filter_conditions_attributes: [:id, :field, :operator, :value, :position, :_destroy]
      ]
    )
  end
end
