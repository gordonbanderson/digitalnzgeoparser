class Coverage < ActiveRecord::Base
    has_permalink :name, :update => true
    has_and_belongs_to_many :natlib_metadatas
    

end
