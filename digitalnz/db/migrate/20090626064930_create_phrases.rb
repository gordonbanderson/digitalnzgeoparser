class CreatePhrases < ActiveRecord::Migration
  def self.up
    create_table :phrases do |t|
      t.string :words
      #t.integer :submission_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phrases
  end
end
