class GeoparsedView < ActiveRecord::Migration
  def self.up
      
      c = ActiveRecord::Base.connection()
      classname = c.class.to_s
      puts classname
      
      #MySQL has a limit on length of index key
      if classname == 'ActiveRecord::ConnectionAdapters::MysqlAdapter'
          c.execute 'create index natlib_title_index on natlib_metadatas(title(255));'
          c.execute 'create index natlib_content_partner_index on natlib_metadatas(content_partner(255));'
      else
          add_index :natlib_metadatas, :title
          add_index :natlib_metadatas, :content_partner
      end
      
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
      remove_index :submissions, :area
      remove_index :natlib_metadatas, :title
      remove_index :natlib_metadatas, :content_partner
      ActiveRecord::Base.connection().execute('drop view geoparsed_records')
  end
end
