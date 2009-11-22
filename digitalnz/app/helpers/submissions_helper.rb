module SubmissionsHelper
    def self.pretty_area(area)
      result = 'No area defined'
      if !area.blank?
        result = area.round 
      end
      result
    end
end
