class CreateFacetFields < ActiveRecord::Migration
    
    #Definition of facet fields prior to adding permalink - the has permalink breaks this migration :(
    class FacetField < ActiveRecord::Base;
        acts_as_tree

          validates_uniqueness_of :name, :scope => 'parent_id'
    end
    
    
  def self.up
      

      
      
      
    create_table :facet_fields do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
    #category, content_partner, creator, language, rights, century, decade, and year
    FacetField::create :name=>'category'
    FacetField::create :name=>'content_partner'
    FacetField::create :name=>'creator'
    FacetField::create :name=>'language'
    FacetField::create :name=>'rights'
    FacetField::create :name=>'century'
    FacetField::create :name=>'decade'
    FacetField::create :name=>'year'
  end

  def self.down
    drop_table :facet_fields
  end
end
