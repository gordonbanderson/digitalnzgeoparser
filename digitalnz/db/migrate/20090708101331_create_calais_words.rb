class CreateCalaisWords < ActiveRecord::Migration
  def self.up
    create_table :calais_words do |t|
      t.string :word

      t.timestamps
    end
  end

  def self.down
    drop_table :calais_words
  end
end
