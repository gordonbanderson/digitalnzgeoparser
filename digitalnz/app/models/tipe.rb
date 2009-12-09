class Tipe < ActiveRecord::Base
  has_many :natlib_metadatas
  
  validates_uniqueness_of :name
  
end
