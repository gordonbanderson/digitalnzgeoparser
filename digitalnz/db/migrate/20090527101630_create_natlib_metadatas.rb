class CreateNatlibMetadatas < ActiveRecord::Migration
  def self.up
    create_table :natlib_metadatas do |t|
      t.string :creator
      t.string :contributor
      t.text :description
      t.string :language
      t.string :publisher
      t.text :title
      t.string :collection
      t.string :landing_url
      t.string :thumbnail_url
      t.integer :tipe_id
      t.string :content_partner
      t.boolean :circa_date
      t.integer :natlib_id
      t.timestamps
    end
  end

  def self.down
    drop_table :natlib_metadatas
  end
end
