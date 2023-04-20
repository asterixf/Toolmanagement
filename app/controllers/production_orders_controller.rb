class ProductionOrdersController < ApplicationController
  def index
    @production_orders = ProductionOrder.all
  end

  def new
    @tool = Tool.find(params[:tool_id])
    @production_order = ProductionOrder.new
  end

  def create
    @tool = Tool.find(params[:tool_id])
    @production_order = ProductionOrder.new(production_order_params)
    fill_production_order_fields
    if @production_order.save
      @tool.update(location: "production")
      redirect_to tool_path(@tool)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def production_order_params
    params.require(:production_order).permit(:cavities_in_tool, :comments)
  end

  def fill_production_order_fields
    @production_order.tool = @tool
    @production_order.status = "open"
    @production_order.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
  end
end
