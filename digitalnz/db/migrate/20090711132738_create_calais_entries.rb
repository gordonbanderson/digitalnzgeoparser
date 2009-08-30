class CreateCalaisEntries < ActiveRecord::Migration
  def self.up
    create_table :calais_entries do |t|
      t.integer :calais_child_word_id
      t.integer :calais_parent_word_id
      t.integer :calais_submission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :calais_entries
  end
end
