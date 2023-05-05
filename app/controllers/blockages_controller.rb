class BlockagesController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
    else
      today = Date.current
      @start_time = today.beginning_of_day
      @end_time = today.end_of_day
    end
    @blockages = Blockage.where(created_at: start_time..end_time)
  end

  def show
    @blockage = Blockage.find(params[:id])
  end

  def new
    @blockage = Blockage.new
  end

  def create
    @blockage = Blockage.new(blockage_params)
    @cavity = Cavity.find(params[:blockage][:cavity_id])
    set_blockage_values
    if @blockage.save
      update_cavities_in_tool
      redirect_to tools_production_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def blockage_params
    params.require(:blockage).permit(:reason, :cavity_id, :comments)
  end

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end

  def set_blockage_values
    @blockage.tool = @tool
    @blockage.status = "open"
    @blockage.created_by = "#{current_user.name} #{current_user.lastname}"
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
