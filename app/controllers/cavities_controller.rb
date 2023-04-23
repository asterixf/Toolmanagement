class CavitiesController < ApplicationController
  before_action :set_tool, only: [:new, :create]
  def index
    @cavities = Cavity.all
  end

  def new
    @cavity = Cavity.new
  end

  def create
    @cavity = Cavity.new(cavity_params)
    @cavity.tool = @tool
    @cavity.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
    if @cavity.save
      update_active_spares
      @tool.update_available
      redirect_to tool_path(@tool)
      flash[:notice] = "Cavity created succesfully!"
    else
      flash[:alert] = "Error: num and satatus can't be blank / cavity num should be unique in tool  "
      redirect_to tool_path(@tool)
    end
  end

  def edit
    @cavity = Cavity.find(params[:id])
  end

  def update
    @cavity = Cavity.find(params[:id])
    @tool = @cavity.tool
    @cavity.last_updated_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
    if @cavity.update(cavity_params)
      update_active_spares
      @tool.update_available
      redirect_to tool_path(@tool)
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private

  def cavity_params
    params.require(:cavity).permit(:num, :is_spare, :status)
  end

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end

  def update_active_spares
    active = @tool.cavities.where(status: "released", is_spare: false).count
    spares = @tool.cavities.where(is_spare: true).count
    @tool.update(active: active, spares: spares)
    @tool.update_available
  end
end
