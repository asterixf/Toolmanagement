class WashOrdersController < ApplicationController

  def show
    @wash_order = WashOrder.find(params[:id])
  end

  def new
    @wash_order = WashOrder.new
  end

  def create
    @wash_order = WashOrder.new(washorder_paramas)
    @wash_order.created_by = "#{current_user.name} #{current_user.lastname}"
    @wash_order.status = "In_process"
    update_tool_blocked
    if @wash_order.save
      redirect_to dashboard_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def washorder_paramas
    params.require(:wash_order).permit(:tool_id, :qty, :comments)
  end

  def update_tool_blocked
    @wash_order.tool.blocked = @wash_order.tool.blocked + @wash_order.qty
    @wash_order.tool.save
  end
end
