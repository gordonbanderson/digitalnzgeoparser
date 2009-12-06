class RejigCalaisEntries < ActiveRecord::Migration
  def self.up
      #Not used yet so ignore migrating data
      remove_column :calais_entries, :calais_submission_id
      drop_table :calais_parent_words
      drop_table :calais_child_words

      #Has and belongs to many join between calais entries and submissions
      create_table :calais_entries_submissions, :id => false do |t|
        t.integer :calais_entry_id
        t.integer :submission_id
        t.timestamps
      end
      
      
  end

  def self.down
      add_column :calais_entries, :calais_submission_id, :integer
      
      create_table :calais_parent_words do |t|
        t.integer :calais_word_id
        t.timestamps
      end
      
      create_table :calais_child_words do |t|
        t.integer :calais_word_id
        t.timestamps
      end

      #This data will be lost
      drop_table :calais_entries_submissions
  end
end
