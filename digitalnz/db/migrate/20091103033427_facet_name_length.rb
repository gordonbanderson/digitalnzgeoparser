class FacetNameLength < ActiveRecord::Migration
  def self.up
    rename_table :facet_fields, :facet_fields_old
    sql = ActiveRecord::Base.connection()
    #sql.begin_db_transaction
    create_table :facet_fields do |t|
      t.text :name
      t.integer :parent_id

      t.timestamps
    end
    
    sql.execute("INSERT INTO facet_fields SELECT * FROM facet_fields_old")
    #sql.commit_db_transaction
    
  end

  def self.down
  end
end
