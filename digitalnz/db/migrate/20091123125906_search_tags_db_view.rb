class SearchTagsDbView < ActiveRecord::Migration
  def self.up
      sql=<<-EOF
        create view search_term_tags as
        select search_text, count(search_text) as c
        from archive_searches group by search_text
        order by c desc, search_text limit 30;
        EOF

        ActiveRecord::Base.connection().execute(sql)
  end

  def self.down
  end
end


=begin
=end