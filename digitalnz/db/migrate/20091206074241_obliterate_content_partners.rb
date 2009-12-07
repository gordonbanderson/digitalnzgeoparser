class ObliterateContentPartners < ActiveRecord::Migration
  def self.up
      



      #Has and belongs to many join between calais entries and submissions
      create_table :content_partners_natlib_metadatas, :id => false do |t|
        t.integer :content_partner_id
        t.integer :natlib_metadata_id
        t.timestamps
      end
      
      
      
      sql=<<-EOF
      create view geoparsed_records as
      select n.title,n.landing_url,n.thumbnail_url,n.description,
      n.pending,n.natlib_id, s.area from natlib_metadatas n
      inner join submissions s
      on (s.natlib_metadata_id = n.id)
      where n.pending = false
      ;
      EOF
      
      ActiveRecord::Base.connection().execute('drop view geoparsed_records')
      ActiveRecord::Base.connection().execute(sql)
      
      #Remove content partners from natlib metadatas
      puts "******* THIS MIGRATION WILL DESTROY DATA ********"
      remove_column :natlib_metadatas, :content_partner
      
  end

  def self.down
      drop_table :content_partners_natlib_metadatas
      add_column :natlib_metadatas, :content_partner, :text
      
      ActiveRecord::Base.connection().execute("drop view geoparsed_records")
      
      sql=<<-EOF
      create view geoparsed_records as
      select n.title,n.landing_url,n.thumbnail_url,n.content_partner, n.description,
      n.pending,n.natlib_id, s.area from natlib_metadatas n
      inner join submissions s
      on (s.natlib_metadata_id = n.id)
      where n.pending = false
      ;
      EOF
      
      ActiveRecord::Base.connection().execute(sql)
      
      
  end
end
