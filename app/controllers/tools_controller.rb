class ToolsController < ApplicationController
  def index
    if params[:query].present?
      @tools = Tool.search_by_params(params[:query]).order(location: :asc)
    else
      @tools = Tool.all.order(location: :asc)
    end
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@tools), filename: "tools-#{Time.now.strftime('%y%m%d')}.csv" }
    end
    @average_availability = Tool.all.average(:available)&.round(2) || 0
    @damper_availability = Tool.where(bu: "Damper").average(:available)&.round(2) || 0
    @steering_availability = Tool.where(bu: "Steering").average(:available)&.round(2) || 0
    @low_volume_availability = Tool.where(bu: "Low_Volume").average(:available)&.round(2) || 0
  end

  def blockages_history
    @tool = Tool.find(params[:tool_id])
    @tool_blockages = @tool.blockages.order(id: :desc)
  end

  def production
    if params[:query].present?
      @tools = Tool.search_by_params(params[:query]).where(location: "production").or(Tool.where(location: "washing")).order(location: :desc)
    else
      @tools = Tool.where(location: "production").or(Tool.where(location: "washing")).order(location: :desc)
    end
    @wash_orders_in_process = WashOrder.where(status: "open").count
  end

  def show
    @tool = Tool.find(params[:id])
    @cavity = Cavity.new
    @cavities = @tool.cavities.order(status: :asc)
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
