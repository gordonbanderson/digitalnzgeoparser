class Coverage < ActiveRecord::Base
    has_permalink :name, :update => true
    belongs_to :natlib_metadata
    

end
