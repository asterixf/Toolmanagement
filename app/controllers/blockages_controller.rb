class BlockagesController < ApplicationController

  def index
    @tools_wash = Tool.joins(:blockages)
                      .where(blockages: { reason: "wash" })
                      .group(:id)
                      .having("COUNT(blockages.id) >= ?", 1)
    @tools_damaged = Tool.joins(:blockages)
                         .where(blockages: { reason: "damaged" })
                         .group(:id)
                         .having("COUNT(blockages.id) >= ?", 1)
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
    params.require(:blockage).permit(:reason, :cavity_id)
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
