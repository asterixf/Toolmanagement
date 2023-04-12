class Tool < ApplicationRecord
  belongs_to :user

  def set_segment
    if volume
      if volume < 50000
        segment = "LV"
      elsif volume < 500000
        segment = "MV"
      else
        segment = "HV"
      end
    end
  end

  def set_available
    active = max - damaged - blocked
    available = active / max.to_f
  end
end
