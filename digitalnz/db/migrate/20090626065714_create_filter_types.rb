class CreateFilterTypes < ActiveRecord::Migration
  def self.up
    create_table :filter_types do |t|
      t.string :name

      t.timestamps
    end
    
    FilterType::create :name => 'no_geocoder_matches'
    FilterType::create :name => 'filtered_by_calais'
    FilterType::create :name => 'outside_yahoo_bounding_box'
    FilterType::create :name => 'stopped'
    FilterType::create :name => 'too_short'
    FilterType::create :name => 'geoparser_failed'
  end

  def self.down
    drop_table :filter_types
  end
end
