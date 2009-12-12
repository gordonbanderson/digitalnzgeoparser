class Category < ActiveRecord::Base
    has_and_belongs_to_many :natlib_metadatas, :include => [:contributors, :categories, :record_dates, :submission]
  has_permalink :name, :update => true
  
  validates_uniqueness_of :name
  
  
  def self.find_or_create the_name
    o = Category.find_by_name the_name
    o = Category::create :name => the_name   if o.blank?
    o  
  end
  
end
