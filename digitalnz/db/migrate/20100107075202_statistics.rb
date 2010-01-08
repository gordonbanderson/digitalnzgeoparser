class Statistics < ActiveRecord::Migration
  def self.up
      create_table :statistics do |t|
        t.string :name
        t.integer :value
        t.timestamps        
      end
      
      add_index :statistics, :name, :unique => true
      
      
      Statistic.create :name => 'digitalnzhits', :value => 0
      Statistic.create :name => 'googlegeocoderhits', :value => 0
      

  end

  def self.down
      remove_index :statistics, :name
      drop_table :statistics
  end
end
