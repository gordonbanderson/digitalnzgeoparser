class FacetField < ActiveRecord::Base
  acts_as_tree
  
  validates_uniqueness_of :name, :scope => 'parent_id'
  has_permalink :name, :update => true
  
  def self.find_or_create the_name
    o = FacetField.find_by_name the_name
    o = FacetField::create :name => the_name   if o.blank?
    o  
  end
  
  def self.find_or_create_with_parent parent_id, the_name
    o = FacetField.find(:first, :conditions =>["parent_id = ? and name = ?", parent_id, the_name])
    o = FacetField::create :name => the_name, :parent_id => parent_id   if o.blank?
    o  
  end
  
end
