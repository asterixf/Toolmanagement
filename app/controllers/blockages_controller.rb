class BlockagesController < ApplicationController

  def index
    @blockages = Blockage.all
  end

  def new
    @tool = Tool.find(params[:tool_id])
    @blockage = Blockage.new
  end

  def create
    @tool = Tool.find(params[:tool_id])
    @blockage = Blockage.new(blockage_params)
    set_blockage_values
    if @blockage.save
      update_tool_blocked_damaged
      update_active
      redirect_to blockages_path
    else
      render :new, status: :unprocessable_entity

    end
  end

  private

  def blockage_params
    params.require(:blockage).permit(:reason)
  end

  def set_blockage_values
    @blockage.tool = @tool
    @blockage.status = "open"
    @blockage.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
  end

  def update_tool_blocked_damaged
    blocked_cavities = @tool.blockages.where(status: "open", reason: "wash").count
    @tool.update(blocked: blocked_cavities)
    damaged_cavities = @tool.blockages.where(status: "open", reason: "damaged").count
    @tool.update(damaged: damaged_cavities)
  end

  def update_active
    updated_active = @tool.active - (@tool.damaged + @tool.blocked)
    @tool.update(active: updated_active)
    @tool.update_available
  end
end
