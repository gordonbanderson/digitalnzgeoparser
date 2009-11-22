class GeoparsedView < ActiveRecord::Migration
  def self.up
      add_index :submissions, :area
      add_index :natlib_metadatas, :title
      add_index :natlib_metadatas, :content_partner
      
      sql=<<-EOF
      create view geoparsed_records as
      select n.title,n.landing_url,n.thumbnail_url,n.description,n.content_partner,
      n.pending,n.natlib_id, s.area from natlib_metadatas n
      inner join submissions s
      on (s.natlib_metadata_id = n.id)
      where n.pending = false
      ;
      EOF
      
      ActiveRecord::Base.connection().execute(sql)
  end

  def self.down
      remove_index :submissions, :area
      remove_index :natlib_metadatas, :title
      remove_index :natlib_metadatas, :content_partner
      ActiveRecord::Base.connection().execute('drop view geoparsed_records')
  end
end
