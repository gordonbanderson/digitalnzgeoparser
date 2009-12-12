class TipesPermalink < ActiveRecord::Migration
  def self.up
      add_column :tipes, :permalink, :string
      for tipe in Tipe.find(:all)
         tipe.save! 
      end
  end

  def self.down
      remove_column :tipes, :permalink
  end
end
