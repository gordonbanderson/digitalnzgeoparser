class DatelineSpatialHack < ActiveRecord::Migration
  def self.up
    span_dateline_locations = CachedGeoSearch.find(:all,
      :conditions => ["bbox_east < bbox_west"]
    )
    for cgs in span_dateline_locations
      cgs.spatialize #This will now add 360 to the easting
    end
    
  end

  def self.down
  end
end
