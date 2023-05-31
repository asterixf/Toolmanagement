class CavitiesController < ApplicationController
  before_action :set_tool, only: [:new, :create]
  # def index
  #   @cavities = Cavity.all
  # end

  def show
    @cavity = Cavity.find(params[:id])
    authorize @cavity
  end

  def new
    @cavity = Cavity.new
    authorize @cavity
  end

  def create
    @cavity = Cavity.new(cavity_params)
    authorize @cavity
    @cavity.tool = @tool
    @cavity.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
    if @cavity.save
      update_active_spares
      @tool.update_available
      redirect_to tool_path(@tool)
      flash[:notice] = "Cavity created succesfully!"
    else
      flash[:alert] = "Error: num and satatus can't be blank "
      redirect_to tool_path(@tool)
    end
  end

  def edit
    @cavity = Cavity.find(params[:id])
    authorize @cavity
  end

  def update
    @cavity = Cavity.find(params[:id])
    authorize @cavity
    @tool = @cavity.tool
    @cavity.last_updated_by = "#{current_user.name} #{current_user.lastname}"
    if @cavity.update(cavity_params)
      update_active_spares
      @tool.update_available
      redirect_to tool_path(@tool)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cavity = Cavity.find(params[:id])
    @tool = @cavity.tool
    authorize @cavity
    @cavity.destroy
    update_blocked_damaged
    update_active_spares
    @tool.update_available
    flash[:alert] = "Cavity deleted succesfully!"
    redirect_to tool_path(@tool)
  end

  private

  def cavity_params
    params.require(:cavity).permit(:num, :is_spare, :status, :comments)
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

  def update_blocked_damaged
    blocked = @tool.cavities.where(status: "blocked").count
    damaged = @tool.cavities.where(status: "damaged").count
    @tool.update(blocked: blocked, damaged: damaged)
  end
end
