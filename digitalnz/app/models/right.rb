class Right < ActiveRecord::Base
  has_and_belongs_to_many :natlib_metadatas
  
end
