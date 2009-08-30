class CreateStopWords < ActiveRecord::Migration
  def self.up
    create_table :stop_words do |t|
      t.string :word

      t.timestamps
    end
  end

  def self.down
    drop_table :stop_words
  end
end
