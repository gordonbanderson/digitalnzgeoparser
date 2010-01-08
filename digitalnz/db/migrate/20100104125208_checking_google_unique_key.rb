class CheckingGoogleUniqueKey < ActiveRecord::Migration
  def self.up
       add_column :cached_geo_searches, :signature, :string
  end

  def self.down
      remove_column :cached_geo_searches, :signature
  end
end
