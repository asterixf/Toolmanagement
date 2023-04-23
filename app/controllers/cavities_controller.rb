class CavitiesController < ApplicationController
  before_action :set_tool, only: [:new, :create, :edit, :update]
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
      update_active_cavities(@tool)
      @tool.update_available
      redirect_to tool_path(@tool)
    else
      flash[:alert] = "Error: num and satatus can't be blank / cavity num should be unique in tool  "
      redirect_to tool_path(@tool)
    end
  end

  def edit
    @cavity = Cavity.find(params[:cavity_id])
  end

  def update
    @cavity = Cavity.find(params[:cavity_id])
    @cavity.last_updated_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
    if @cavity.update(cavity_params)
      update_active_cavities(@tool)
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

  def update_active_cavities(tool)
    active_cavities = tool.cavities.where(status: "released", is_spare: false)
    spare_cavities = tool.cavities.where(is_spare: true)
    tool.update(active: active_cavities.count, spares: spare_cavities.count)
  end
end
