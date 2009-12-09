class Identifier < ActiveRecord::Base
  has_and_belongs_to_many :natlib_metadatas
  has_permalink :name, :update => true
  
  def self.find_or_create the_name
    o = Identifier.find_by_name the_name
    o = Identifier::create :name => the_name   if o.blank?
    o  
  end
  
end
