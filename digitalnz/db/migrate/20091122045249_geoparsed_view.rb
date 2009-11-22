class GeoparsedView < ActiveRecord::Migration
  def self.up
      add_index :submissions, :area
      
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
      drop_index :submissions, :area
      ActiveRecord::Base.connection().execute('drop view geoparsed_records')
  end
end
