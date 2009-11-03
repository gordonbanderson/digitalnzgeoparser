class Byebyevarchar255 < ActiveRecord::Migration
  def self.up
    rename_table :natlib_metadatas, :natlib_metadatas_old
    sql = ActiveRecord::Base.connection()
        sql.begin_db_transaction
    create_table :natlib_metadatas do |t|
      t.text :creator
      t.text :contributor
      t.text :description
      t.text :language
      t.text :publisher
      t.text :title
      t.text :collection
      t.text :landing_url
      t.text :thumbnail_url
      t.integer :tipe_id
      t.text :content_partner
      t.boolean :circa_date
      t.integer :natlib_id
      t.timestamps
    end
    
    sql.execute("INSERT INTO natlib_metadatas SELECT * FROM natlib_metadatas_old")
    sql.commit_db_transaction
    
    
    
  end

  def self.down
  end
end
