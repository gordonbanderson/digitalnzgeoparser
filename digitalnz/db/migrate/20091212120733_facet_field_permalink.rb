class FacetFieldPermalink < ActiveRecord::Migration
  def self.up
      
      FacetField.reset_column_information
      
      add_column :facet_fields, :permalink, :string
      for f in FacetField.find(:all)
         f.save! 
      end
  end

  def self.down
      remove_column :facet_fields, :permalink
  end
end
