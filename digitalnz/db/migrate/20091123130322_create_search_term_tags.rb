class CreateSearchTermTags < ActiveRecord::Migration
  def self.up
          sql=<<-EOF
            create view geoparsed_locations as 

            select s.id as submission_id,
            nm.natlib_id as natlib_metadata_id,
            nm.title as title,
            cgss.cached_geo_search_id,
            cgst.search_term,
            cgs.accuracy_id,
            cgs.address

            from submissions s

            inner join natlib_metadatas nm
            on (s.natlib_metadata_id = nm.id)

            inner join cached_geo_searches_submissions cgss
            on (s.id = cgss.submission_id)

            inner join cached_geo_searches cgs
            on (cgss.cached_geo_search_id = cgs.id)

            inner join cached_geo_search_terms cgst
            on (cgs.cached_geo_search_term_id = cgst.id)

            order by address, title;
            EOF

            ActiveRecord::Base.connection().execute(sql)
      end

      def self.down
      end
end
