class ToolsController < ApplicationController
  def index
    @tools = Tool.all
    @average_availability = @tools.average(:available)
      respond_to do |format|
        format.html
        format.csv { send_data @tools.to_csv, filename: "tools-#{Time.now.strftime('%y%m%d')}.csv" }
      end
  end

  def show
    @tool = Tool.find(params[:id])
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)
    @tool.last_updated_by = "#{current_user.name} #{current_user.lastname}"
    @tool.damaged = 0
    @tool.blocked = 0
    set_active
    @tool.available = 100
    @tool.plant = current_user.plant
    @tool.location = "stored"
    if @tool.save
      redirect_to tools_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def tool_params
    params.require(:tool).permit(:alias, :sap, :capacity, :technology, :bu, :volume,
      :customer, :capacity, :spares, :segment, :layout)
  end

  def set_active
    if @tool.capacity
      @tool.active = @tool.capacity
    end
  end
end
