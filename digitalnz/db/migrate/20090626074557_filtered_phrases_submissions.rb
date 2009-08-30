class FilteredPhrasesSubmissions < ActiveRecord::Migration
  def self.up
    create_table :filtered_phrases_submissions, :id => false do |t|
      t.integer :submission_id
      t.integer :filtered_phrase_id
    end
  end

  def self.down
    drop_table :filtered_phrases_submissions
  end
end
