class Placename < ActiveRecord::Base
    has_and_belongs_to_many :natlib_metadatas
    has_permalink :name, :update => true  
end
