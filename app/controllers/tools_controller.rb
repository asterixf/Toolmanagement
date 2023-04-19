class ToolsController < ApplicationController
  def index
    if params[:query].present?
      @tools = Tool.search_by_params(params[:query]).order(updated_at: :desc)
    else
      @tools = Tool.all.order(updated_at: :desc)
    end
    @average_availability = @tools.average(:available)
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@tools), filename: "tools-#{Time.now.strftime('%y%m%d')}.csv" }
    end
  end

  def show
    @tool = Tool.find(params[:id])
    @cavity = Cavity.new
    @cavities = @tool.cavities
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)
    set_tool_values
    if @tool.save
      redirect_to tool_path(@tool)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tool = Tool.find(params[:id])
  end

  def update
    @tool = Tool.find(params[:id])
    params[:tool][:active] = params[:tool][:capacity]
    if @tool.update(tool_params)
      redirect_to tool_path(@tool)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def tool_params
    params.require(:tool).permit(:alias, :sap, :capacity, :technology, :bu, :volume,
                                 :customer, :capacity, :segment, :layout)
  end

  def set_tool_values
    @tool.created_by = "#{current_user.id}-#{current_user.name} #{current_user.lastname}"
    @tool.last_updated_by = @tool.created_by
    @tool.active = 0
    @tool.damaged = 0
    @tool.blocked = 0
    @tool.spares = 0
    @tool.available = 100
    @tool.plant = current_user.plant
    @tool.location = "stored"
  end

  def to_csv(tools)
    attribs = [:id, :alias, :sap, :plant, :bu, :technology, :volume, :customer,
               :capacity, :location, :damaged, :blocked, :active, :spares, :segment, :available]
    CSV.generate(headers: true) do |csv|
      csv << attribs
      tools.each do |tool|
        csv << attribs.map{ |attr| tool.send(attr) }
      end
    end
  end
end
