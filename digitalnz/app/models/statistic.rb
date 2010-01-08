class Statistic < ActiveRecord::Base
    
    def self.increment(the_name)
       stat = Statistic.find_by_name the_name
       stat = Statistic::create :name => the_name, :value => 0 if stat.blank?
       stat.value = stat.value + 1
       stat.save
    end
end
