class CreateArchiveSearches < ActiveRecord::Migration
  def self.up
    create_table :archive_searches do |t|
      t.string :search_text
      t.integer :num_results_request
      t.integer :page
      t.float :elapsed_time
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_searches
  end
end
