class WashOrdersController < ApplicationController
  before_action :set_tool, only: [:new, :create]
  def new
    @wash_order = WashOrder.new
  end

  private

  def set_tool
    @tool = Tool.find(params[:tool_id])
  end
end
