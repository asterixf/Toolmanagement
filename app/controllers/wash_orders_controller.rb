class WashOrdersController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
    @wash_orders = policy_scope(WashOrder)
    if params[:start_date].present? && params[:end_date].present?
      @start_date = Date.parse(params[:start_date])
      @end_date = Date.parse(params[:end_date])
      start_time = Time.new(@start_date.year, @start_date.month, @start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(@end_date.year, @end_date.month, @end_date.day, 23, 59, 59, "+00:00")
    else
      today = (Time.now - 6.hours).to_date
      start_time = today.beginning_of_day
      end_time = today.end_of_day
    end
    start_time += 6.hours
    end_time += 6.hours
    @wash_orders = WashOrder.where(created_at: start_time..end_time).order(created_at: :asc)
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@wash_orders), filename: "WO-#{Time.now.strftime('%y%m%d')}.csv" }
    end
  end

  def show
    @wash_order = WashOrder.find(params[:id])
    authorize @wash_order
  end

  def new
    @wash_order = WashOrder.new
    authorize @wash_order
  end

  def create
    @wash_order = WashOrder.new(washorder_paramas)
    authorize @wash_order
    set_wash_order_values
    if @wash_order.tool.active_wash_order?
      if @wash_order.save
        @tool.update(location:"washing")
        redirect_to tools_production_path
      else
        render :new, status: :unprocessable_entity
      end
    else
      flash[:alert] = "Tool has an open wash order"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @wash_order = WashOrder.find(params[:id])
    authorize @wash_order
  end

  def update
    @wash_order = WashOrder.find(params[:id])
    authorize @wash_order
    if @wash_order.active_sub_process
      flash[:alert] = "You can't edit an order with an active sub-process"
      render :edit, status: :unprocessable_entity
    elsif @wash_order.update(washorder_paramas)
      if @wash_order.status === "close"
        @wash_order.tool.update(location:"production")
        @wash_order.update(
          closed_by: "#{current_user.name} #{current_user.lastname}",
          closed_at: Time.current,
          time: @wash_order.total_time
        )
        @wash_order.update(wash_time: @wash_order.manual_process_start ? @wash_order.wash_time_minus_manual_process : @wash_order.time)
      end
      redirect_to tools_production_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def manual_process
    @wash_order = WashOrder.find(params[:id])
    authorize @wash_order
    if @wash_order.manual_process_start.nil?
      @wash_order.update(manual_process_start: Time.current)
    else
      @wash_order.update(manual_process_end: Time.current)
    end
    redirect_to tools_production_path
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
    attribs = [:id, :created_date, :created_time, :closed_date, :closed_time, :created_by, :wash_time, :total_time, :tool_sap, :tool_alias, :tool_bu, :tech]
    if wash_orders && wash_orders.any?
      CSV.generate(headers: true) do |csv|
        csv << attribs
        wash_orders.each do |order|
          csv << attribs.map do |attr|
            case attr
            when :created_date
              order.created_at.in_time_zone('America/Mexico_City').strftime("%Y-%m-%d")
            when :created_time
              order.created_at.in_time_zone('America/Mexico_City').strftime("%H:%M:%S")
            when :closed_date
              if order.closed_at.present?
                order.closed_at.in_time_zone('America/Mexico_City').strftime("%Y-%m-%d")
              else
                ""
              end
            when :closed_time
              if order.closed_at.present?
                order.closed_at.in_time_zone('America/Mexico_City').strftime("%H:%M:%S")
              else
                ""
              end
            when :tool_sap
              order.tool.sap
            when :tool_alias
              order.tool.alias
            when :tool_bu
              order.tool.bu
            when :tech
              order.tool.technology
            when :wash_time
              if order.wash_time.present?
                order.formatted_wash_time
              else
                ""
              end
            when :total_time
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
    else
      CSV.generate(headers: true) do |csv|
        csv << attribs
      end
    end
  end
end
