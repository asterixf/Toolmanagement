class DamageReportsController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def new
    @damage_report = DamageReport.new
    @blockages = @tool.blockages.where(reason: "damaged", status: "open")
  end

  def create
    @damage_report = DamageReport.new(damagereport_paramas)
    set_damage_report_values
    @blockages = @tool.blockages.where(reason: "damaged", status: "open")
    @damage_report.blockages = @blockages
    if @damage_report.save
      redirect_to d_blockages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @damage_report = DamageReport.find(params[:id])
  end

  def update
    @damage_report = DamageReport.find(params[:id])
    if @damage_report.update(damagereport_paramas)
      if @damage_report.status === "close"
        @damage_report.update(
          closed_by: "#{current_user.name} #{current_user.lastname}"
        )
        update_blockages_cavities
      end
      redirect_to damage_report_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def damagereport_paramas
    params.require(:damage_report).permit(:machine_num, :shift, :operator, :bcl, :process_eng, :damaged_part, :description, :cause, :comments, :status)
  end

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end

  def set_damage_report_values
    @damage_report.tool = @tool
    @damage_report.created_by = "#{current_user.name} #{current_user.lastname}"
    @damage_report.status = "open"
  end

  def update_blockages_cavities
    @damage_report.blockages.where(reason: "damaged", status: "open").each do |blockage|
      blockage.update(status: "close", last_updated_by: "#{current_user.id}-#{current_user.name} #{current_user.lastname}")
      blockage.cavity.update(status: "released")
      update_tool_cavities
    end
  end
  def update_tool_cavities
    tool = @wash_order.tool
    blocked = tool.cavities.where(status: "blocked").count
    damaged = tool.cavities.where(status: "damaged").count
    active = tool.cavities.where(status: "released", is_spare: false).count
    tool.update(active: active, blocked: blocked, damaged: damaged)
    tool.update_available
  end
end
