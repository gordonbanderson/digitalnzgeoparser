class FacetField < ActiveRecord::Base
  acts_as_tree
  
  validates_uniqueness_of :name, :scope => 'parent_id'
  has_permalink :name, :update => true
  
  def self.find_or_create the_name
    o = FacetField.find_by_name the_name
    o = FacetField::create :name => the_name   if o.blank?
    o  
  end
  
end
