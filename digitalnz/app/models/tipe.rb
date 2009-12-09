class Tipe < ActiveRecord::Base
  has_and_belongs_to_many :natlib_metadatas
  
  validates_uniqueness_of :name
  
end
