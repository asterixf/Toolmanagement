class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    if Tool.all.empty?
      @average_availability = 0
    else
      @average_availability = Tool.all.average(:available)
    end
  end
end
