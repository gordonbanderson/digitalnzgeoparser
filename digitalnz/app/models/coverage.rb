class Coverage < ActiveRecord::Base
    has_permalink :name, :update => true
    has_and_belongs_to_many :natlib_metadatas
    
    validates_uniqueness_of :name
    
    
    def self.find_or_create the_name
      o = Coverage.find_by_name the_name
      o = Coverage::create :name => the_name   if o.blank?
      o  
    end
    

end
