class CoveragesHabtm < ActiveRecord::Migration
  def self.up
      drop_table :natlib_metadatas_coverages
      create_table :coverages_natlib_metadatas, :id => false do |t|
        t.integer :coverage_id
        t.integer :natlib_metadata_id
        t.timestamps
      end

  end

  def self.down
      #drop_table :coverages_natlib_metadatas
  end
end
