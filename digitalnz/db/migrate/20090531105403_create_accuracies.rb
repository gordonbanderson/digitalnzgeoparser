class CreateAccuracies < ActiveRecord::Migration
  def self.up
    create_table :accuracies do |t|
      t.string :name
      t.integer :google_id

      t.timestamps
    end
    
    Accuracy.create :name => 'Unknown', :google_id => 0
    Accuracy.create :name => 'Country Level Accuracy', :google_id => 1
    Accuracy.create :name => 'Regional', :google_id => 2
    Accuracy.create :name => 'Sub Region', :google_id => 3
    Accuracy.create :name => 'Town', :google_id => 4
    Accuracy.create :name => 'Post Code', :google_id => 5
    Accuracy.create :name => 'Street', :google_id => 6
    Accuracy.create :name => 'Intersection', :google_id => 7
    Accuracy.create :name => 'Address', :google_id => 8
    Accuracy.create :name => 'Premises', :google_id => 9
  end

  def self.down
    drop_table :accuracies
  end
end
