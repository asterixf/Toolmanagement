class DamageReportsController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def show
    @damage_report = DamageReport.find(params[:id])
  end

  def index
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
      start_utc = start_time.utc
      end_utc = end_time.utc
      @damage_reports = DamageReport.where(created_at: start_utc..end_utc)
    else
      start_time = Time.current.in_time_zone("Central Time (US & Canada)").beginning_of_month
      end_time = Time.current.in_time_zone("Central Time (US & Canada)").end_of_month.end_of_day
      @damage_reports = DamageReport.where(created_at: start_time..end_time)
    end
  end

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
      redirect_to damage_reports_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def damagereport_paramas
    params.require(:damage_report).permit(:machine_num, :shift, :quality, :operator, :bcl, :process_eng, :damaged_part, :description, :cause, :comments, :status)
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
    tool = @damage_report.tool
    blocked = tool.cavities.where(status: "blocked").count
    damaged = tool.cavities.where(status: "damaged").count
    active = tool.cavities.where(status: "released", is_spare: false).count
    tool.update(active: active, blocked: blocked, damaged: damaged)
    tool.update_available
  end
end
