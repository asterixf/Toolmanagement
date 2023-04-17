class ToolsController < ApplicationController
  def index
    if params[:query].present?
      @tools = Tool.search_by_params(params[:query])
    else
      @tools = Tool.all
    end
    @average_availability = @tools.average(:available)
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@tools), filename: "tools-#{Time.now.strftime('%y%m%d')}.csv" }
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
                                 :customer, :capacity, :spares, :segment, :layout, :active)
  end

  def set_active
    if @tool.capacity
      @tool.active = @tool.capacity
    end
  end

  def to_csv(tools)
  # Select the attributes that are needed in csv
    attribs = [:id, :alias, :sap, :plant, :bu, :technology, :volume, :customer, :capacity, :location, :damaged, :blocked, :active, :spares, :segment, :available]
    # iterate over all the passed tools and one by one create row of the csv
    CSV.generate(headers: true) do |csv|
      csv << attribs
      # iterate over the filtered tools and add them to the csv
      tools.each do |tool|
        csv << attribs.map{ |attr| tool.send(attr) }
      end
    end
  end
end
