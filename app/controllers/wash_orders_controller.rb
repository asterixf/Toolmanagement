class WashOrdersController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
      start_utc = start_time.utc
      end_utc = end_time.utc
      @wash_orders = WashOrder.where(created_at: start_utc..end_utc)
    else
      start_time = Time.current.in_time_zone("Central Time (US & Canada)").beginning_of_month
      end_time = Time.current.in_time_zone("Central Time (US & Canada)").end_of_month.end_of_day
      @wash_orders = WashOrder.where(created_at: start_time..end_time)
    end
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(WashOrder.all), filename: "WO-#{Time.now.strftime('%y%m%d')}.csv" }
    end
  end

  def show
    @wash_order = WashOrder.find(params[:id])
  end

  def new
    @wash_order = WashOrder.new
  end

  def create
    @wash_order = WashOrder.new(washorder_paramas)
    set_wash_order_values
    if @wash_order.save
      redirect_to wo_blockages_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @wash_order = WashOrder.find(params[:id])
  end

  def update
    @wash_order = WashOrder.find(params[:id])
    if @wash_order.update(washorder_paramas)
      if @wash_order.status === "close"
        @wash_order.update(
          closed_by: "#{current_user.name} #{current_user.lastname}",
          closed_at: Time.current,
          time: Time.current - @wash_order.created_at
        )
      end
      redirect_to wash_orders_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def download_csv
    if params[:report_start_date].present? && params[:report_end_date].present?
      start_date = Date.parse(params[:report_start_date])
      end_date = Date.parse(params[:report_end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
      start_utc = start_time.utc
      end_utc = end_time.utc
    end
    respond_to do |format|
      format.csv { send_data download_washorder_report(start_utc, end_utc), filename: "WO-#{Time.now.strftime('%y%m%d')}.csv" }
    end
    raise
  end

  private

  def washorder_paramas
    params.require(:wash_order).permit(:comments, :status)
  end

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end

  def set_wash_order_values
    @wash_order.tool = @tool
    @wash_order.created_by = "#{current_user.name} #{current_user.lastname}"
    @wash_order.active = @wash_order.tool.active
    @wash_order.status = "open"
  end

  def to_csv(wash_orders)
    attribs = [:id, :created_at, :closed_at, :created_by, :time_formated, :tool_sap, :tool_alias]
    CSV.generate(headers: true) do |csv|
      csv << attribs
      wash_orders.each do |order|
        csv << attribs.map do |attr|
          case attr
          when :tool_sap
            order.tool.sap
          when :tool_alias
            order.tool.alias
          when :time_formated
            if order.time.present?
            order.formatted_time
            elsif ""
            end
          else
            order.send(attr)
          end
        end
      end
    end
  end
end
