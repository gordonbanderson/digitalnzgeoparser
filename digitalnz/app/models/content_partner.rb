class ContentPartner < ActiveRecord::Base
    has_permalink :name, :update => true
    has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
    
    validates_uniqueness_of :name
    
    
    def self.find_or_create name
      cw = ContentPartner.find_by_name(name)
      cw = ContentPartner::create :name => name   if cw.blank?
      cw  
    end
end
