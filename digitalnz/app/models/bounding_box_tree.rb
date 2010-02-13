class BoundingBoxTree < ActiveRecord::Base
  belongs_to :cached_geo_search
  belongs_to :submission

  acts_as_tree
end
