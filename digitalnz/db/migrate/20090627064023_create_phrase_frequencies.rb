class CreatePhraseFrequencies < ActiveRecord::Migration
  def self.up
    create_table :phrase_frequencies do |t|
      t.integer :submission_id
      t.integer :frequency
      t.integer :phrase_id

      t.timestamps
    end
  end

  def self.down
    drop_table :phrase_frequencies
  end
end
