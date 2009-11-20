class PendingMetadata < ActiveRecord::Migration
  def self.up
    add_column :natlib_metadatas, :pending, :boolean, :default => true
    
  end

  def self.down
    remove_column :natlib_metadatas, :pending
  end
end
