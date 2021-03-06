class Tipe < ActiveRecord::Base
    has_permalink :name, :update => true
    
    has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
  
  validates_uniqueness_of :name
  
end
