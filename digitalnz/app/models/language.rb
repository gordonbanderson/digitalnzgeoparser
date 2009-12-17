class Language < ActiveRecord::Base
    has_permalink :name, :update => true
    has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
    
    validates_uniqueness_of :name
    
    def self.find_or_create name
      cw = Language.find_by_name(name)
      cw = Language::create :name => name   if cw.blank?
      cw  
    end
end
