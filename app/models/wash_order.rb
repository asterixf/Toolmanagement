require 'csv'

class WashOrder < ApplicationRecord
  belongs_to :tool
  validates :status, presence: true

  def formatted_time
    hours = time / 3600
    minutes = (time % 3600) / 60
    seconds = time % 60
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end

  def formatted_wash_time
    hours = wash_time / 3600
    minutes = (wash_time % 3600) / 60
    seconds = wash_time % 60
    format('%02d:%02d:%02d', hours, minutes, seconds)
  end

  def active_sub_process
    return manual_process_start && manual_process_end.nil?
  end

  def total_time
    Time.current - created_at
  end

  def wash_time_minus_manual_process
    time - (manual_process_end - manual_process_start)
  end
end
