module SubmissionsHelper
    def self.pretty_area(area)
      result = 'No area defined'
      
      
      if !area.blank?
          rounded_area = area.round.to_s
            if area < 10
                rounded_area = number_to_n_significant_digits(area,2)
            elsif area < 100
                rounded_area = number_to_n_significant_digits(area,2)

            end
        result = "#{rounded_area} km&sup2;"
      end
      result
    end
    
    
    def self.number_to_n_significant_digits(number, n = 3)
      ("%f"%[("%.#{n}g"%number).to_f]).sub(/\.?0*\z/,'')
    end
end
