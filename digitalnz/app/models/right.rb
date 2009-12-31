class Right < ActiveRecord::Base
  has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
  has_permalink :name, :update => true
  
  validates_uniqueness_of :name
  
  
  def self.find_or_create the_name
        search_name = the_name.clone
        search_name = the_name[0,250]
        o = Right.find_by_name search_name
        o = Right::create :name => search_name   if o.blank?
        o  
  end
  
end
