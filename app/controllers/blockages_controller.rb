class BlockagesController < ApplicationController

  def index
    @tools_wash = Tool.joins(:blockages)
                      .where(blockages: { reason: "wash", status: "open" })
                      .group(:id)
                      .having("COUNT(blockages.id) >= ?", 1)
    @tools_damaged = Tool.joins(:blockages)
                         .where(blockages: { reason: "damaged", status: "open"})
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
    @cavity = Cavity.find(params[:blockage][:cavity_id])
    set_blockage_values
    if @blockage.save
      update_cavities_in_tool
      redirect_to wo_blockages_path
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

  def update_cavities_in_tool
    if @blockage.reason == "wash"
      @cavity.update(status: "blocked")
    elsif @blockage.reason == "damaged"
      @cavity.update(status: "damaged")
    end
    blocked = @tool.cavities.where(status: "blocked").count
    damaged = @tool.cavities.where(status: "damaged").count
    active = @tool.cavities.where(status: "released", is_spare: false).count
    @tool.update(active: active, blocked: blocked, damaged: damaged)
    @tool.update_available
  end
end
