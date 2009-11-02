#!/usr/bin/env ../digitalnz/script/runner

for nl in NatlibMetadata.find_by_sql("select * from natlib_metadatas
where id not in (select natlib_metadata_id from submissions) order by id desc")
  
  puts "ruby geoparse_record.rb  #{nl.natlib_id}"
end