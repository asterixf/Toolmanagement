class DamageReportsController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
    @damage_reports = policy_scope(DamageReport)
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
    else
      today = Date.current
      start_time = today.beginning_of_day
      end_time = today.end_of_day
    end
    @damage_reports = DamageReport.where(created_at: start_time..end_time)
  end

  def show
    @damage_report = DamageReport.find(params[:id])
    authorize @damage_report
  end

  def new
    @damage_report = DamageReport.new
    authorize @damage_report
  end

  def create
    @damage_report = DamageReport.new(damagereport_paramas)
    authorize @damage_report
    set_damage_report_values
    if @damage_report.save
      redirect_to damage_reports_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @damage_report = DamageReport.find(params[:id])
    authorize @damage_report
  end

  def update
    @damage_report = DamageReport.find(params[:id])
    authorize @damage_report
    if @damage_report.update(damagereport_paramas)
      if @damage_report.status == "close"
        @damage_report.update(
          closed_by: "#{current_user.name} #{current_user.lastname}"
        )
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
end
