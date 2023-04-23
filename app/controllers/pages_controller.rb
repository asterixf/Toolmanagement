class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    if Tool.all.empty?
      @average_availability = 0
    else
      @average_availability = Tool.all.average(:available)
      @damper_availability = Tool.where(bu: "Damper").average(:available)
      @steering_availability = Tool.where(bu: "Steering").average(:available)
      @low_volume_availability = Tool.where(bu: "Low_Volume").average(:available)
    end
  end
end
