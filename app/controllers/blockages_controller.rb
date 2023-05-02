class BlockagesController < ApplicationController

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
      wash_damaged_present
      update_cavities_in_tool
      if @blockage.reason == "wash"
      redirect_to wo_blockages_path
      elsif @blockage.reason == "damaged"
        redirect_to d_blockages_path
      end
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

  def wash_damaged_present
    if @tool.wash_orders.where(status: "open").present? && @blockage.reason == "wash"
      @wash_order = @tool.wash_orders.find_by(status: "open")
      @wash_order.blockages << @blockage
    elsif @tool.damage_reports.where(status: "open").present? && @blockage.reason == "damaged"
      @damage_report = @tool.damage_reports.find_by(status: "open")
      @damage_report.blockages << @blockage
    end
  end
end
