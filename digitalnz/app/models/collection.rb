class Collection < ActiveRecord::Base
    has_permalink :name, :update => true
    has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
    
    validates_uniqueness_of :name
    
    def self.find_or_create name
      cw = Collection.find_by_name(name)
      cw = Collection::create :name => name   if cw.blank?
      cw  
    end
end

