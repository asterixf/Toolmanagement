class WashOrdersController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
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
    @wash_orders = WashOrder.where(created_at: start_time..end_time)
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@wash_orders), filename: "WO-#{Time.now.strftime('%y%m%d')}.csv" }
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
      @tool.update(location:"washing")
      redirect_to tools_production_path
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
        @wash_order.tool.update(location:"production")
        @wash_order.update(
          closed_by: "#{current_user.name} #{current_user.lastname}",
          closed_at: Time.current,
          time: Time.current - @wash_order.created_at
        )
      end
      redirect_to tools_production_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
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
    @wash_order.active = @tool.active
    @wash_order.blocked = @tool.blocked
    @wash_order.damaged = @tool.damaged
    @wash_order.created_by = "#{current_user.name} #{current_user.lastname}"
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
            else
              ""
            end
          else
            order.send(attr)
          end
        end
      end
    end
  end
end
