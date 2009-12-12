class Subject < ActiveRecord::Base
  has_permalink :name, :update => true
  has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
  
  validates_uniqueness_of :name
  
  
  def self.find_or_create the_name
    o = Subject.find_by_name the_name
    o = Subject::create :name => the_name   if o.blank?
    o  
  end
  
end
