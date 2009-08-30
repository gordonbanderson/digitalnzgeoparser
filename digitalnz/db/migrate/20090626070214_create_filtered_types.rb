class CreateFilteredTypes < ActiveRecord::Migration
  def self.up
    create_table :filtered_phrases do |t|
      t.integer :phrase_id
      t.integer :filter_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :filtered_phrases
  end
end
