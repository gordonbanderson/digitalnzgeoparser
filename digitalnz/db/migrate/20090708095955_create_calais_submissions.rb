class CreateCalaisSubmissions < ActiveRecord::Migration
  def self.up
    create_table :calais_submissions do |t|
      t.string :signature

      t.timestamps
    end
  end

  def self.down
    drop_table :calais_submissions
  end
end
