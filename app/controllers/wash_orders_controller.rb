class WashOrdersController < ApplicationController
   before_action :set_tool, only: [:new, :create]
  def index
    @wash_orders = WashOrder.all
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
    @wash_order = WashOrder.find(params[:wash_order_id])
    if @wash_order.update(washorder_paramas)
      redirect_to tools_path
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
    @wash_order.created_by = "#{current_user.name} #{current_user.lastname}"
    @wash_order.active = @wash_order.tool.active
    @wash_order.damaged = @wash_order.tool.damaged
    @wash_order.blocked = @wash_order.tool.blocked
    @wash_order.status = "open"
  end
end
