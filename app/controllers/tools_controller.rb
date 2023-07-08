class ToolsController < ApplicationController
  def index
    @tools = policy_scope(Tool)
    if params[:query].present?
      @query = params[:query]
      @tools = Tool.search_by_params(@query).order(location: :asc)
    else
      @tools = Tool.all.order(location: :asc)
    end
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@tools), filename: "tools-#{Time.now.strftime('%y%m%d')}.csv" }
    end
    @average_availability = Tool.all.average(:available)&.round(2) || 0
    @hv_availability = Tool.where(segment: "HV").average(:available)&.round(2) || 0
    @mv_availability = Tool.where(segment: "MV").average(:available)&.round(2) || 0
    @lv_availability = Tool.where(segment: "LV").average(:available)&.round(2) || 0
  end

  def blockages_history
    @tool = Tool.find(params[:id])
    authorize @tool
    @tool_blockages = @tool.blockages.order(id: :desc)
  end

  def production
    if params[:query].present?
      @tools = Tool.search_by_params(params[:query]).where(location: "production").or(Tool.where(location: "washing")).order(location: :desc)
    else
      @tools = Tool.where(location: "production").or(Tool.where(location: "washing")).order(location: :desc)
    end
    authorize @tools
    @wash_orders_in_process = WashOrder.where(status: "open").count
  end

  def show
    @tool = Tool.find(params[:id])
    authorize @tool
    @cavity = Cavity.new
    @cavities = @tool.cavities.order(status: :asc)
  end

  def new
    @tool = Tool.new
    authorize @tool
  end

  def create
    @tool = Tool.new(tool_params)
    authorize @tool
    set_tool_values
    if @tool.save
      redirect_to tool_path(@tool)

    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tool = Tool.find(params[:id])
    authorize @tool
  end

  def update
    @tool = Tool.find(params[:id])
    authorize @tool
    if @tool.update(tool_params)
      @tool.update_available
      @tool.update(last_updated_by:"#{current_user.id}-#{current_user.name} #{current_user.lastname}")
      redirect_to tool_path(@tool)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def tool_params
    params.require(:tool).permit(:alias, :sap, :capacity, :technology, :bu, :volume,
                                 :customer, :capacity, :segment, :layout, :manual_process)
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
