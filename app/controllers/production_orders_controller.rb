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
      redirect_to tools_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @production_order = ProductionOrder.find(params[:id])
  end

  def update
    @production_order = ProductionOrder.find(params[:id])
    if @production_order.update(production_order_params)
      @production_order.update(last_updated_by: "#{current_user.id}-#{current_user.name} #{current_user.lastname}")
        if @production_order.status == "close"
          @production_order.tool.update(location: "stored")
        end
      redirect_to tools_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def production_order_params
    params.require(:production_order).permit(:cavities_in_tool, :comments, :status)
  end

  def fill_production_order_fields
    @production_order.tool = @tool
    @production_order.status = "open"
    @production_order.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
  end
end
