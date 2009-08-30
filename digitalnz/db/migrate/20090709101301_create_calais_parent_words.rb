class CreateCalaisParentWords < ActiveRecord::Migration
  def self.up
    create_table :calais_parent_words do |t|
      t.integer :calais_word_id

      t.timestamps
    end
  end

  def self.down
    drop_table :calais_parent_words
  end
end
