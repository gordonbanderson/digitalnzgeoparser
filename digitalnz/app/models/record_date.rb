class RecordDate < ActiveRecord::Base
belongs_to :natlib_metadata

  def pretty_date
    result = ""
    if start_date == end_date
      result << start_date.to_s
    elsif
      result << start_date.year.to_s
    end
    result
  end
  
end
