class WashOrdersController < ApplicationController
  before_action :set_tool, only: [:new, :create]

  def index
    if params[:start_date] && params[:end_date]
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      start_time = Time.new(start_date.year, start_date.month, start_date.day, 0, 0, 0, "+00:00")
      end_time = Time.new(end_date.year, end_date.month, end_date.day, 23, 59, 59, "+00:00")
      start_utc = start_time.utc
      end_utc = end_time.utc
      @wash_orders = WashOrder.where(created_at: start_utc..end_utc)
    else
      @wash_orders = WashOrder.all
    end
  end

  def show
    @wash_order = WashOrder.find(params[:id])
  end

  def new
    @wash_order = WashOrder.new
    @blockages = @tool.blockages.where(reason: "wash", status: "open")
  end

  def create
    @wash_order = WashOrder.new(washorder_paramas)
    set_wash_order_values
    @blockages = @tool.blockages.where(reason: "wash", status: "open")
    @wash_order.blockages = @blockages
    if @wash_order.save
      redirect_to tools_path
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
        update_blockages_cavities
      end
      redirect_to wash_orders_path
      flash[:notice] = "Order updated succesfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def washorder_paramas
    params.require(:wash_order).permit(:comments, :status)
  end

  def update_blockages_cavities
    @wash_order.blockages.where(reason: "wash").each do |blockage|
      blockage.update(status: "close", last_updated_by: "#{current_user.id}-#{current_user.name} #{current_user.lastname}")
      blockage.cavity.update(status: "released")
      update_tool_cavities
    end
  end

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end

  def set_wash_order_values
    @wash_order.tool = @tool
    @wash_order.created_by = "#{current_user.name} #{current_user.lastname}"
    @wash_order.active = @wash_order.tool.active
    @wash_order.damaged = @wash_order.tool.damaged
    @wash_order.blocked = @wash_order.tool.blocked
    @wash_order.status = "open"
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
