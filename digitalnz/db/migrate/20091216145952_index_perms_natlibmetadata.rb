class IndexPermsNatlibmetadata < ActiveRecord::Migration
  def self.up
      add_index :natlib_metadatas, :permalink, :unique => true
      
  end

  def self.down
      remove_index :natlib_metadatas, :permalink
  end
end
