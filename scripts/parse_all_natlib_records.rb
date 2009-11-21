#!/usr/bin/env ../digitalnz/script/runner
c = 0
current = []
for nl in NatlibMetadata.find_by_sql("select * from natlib_metadatas
where id not in (select natlib_metadata_id from submissions) order by id desc")
  current << nl.natlib_id
  c = c+1
  if c == 4
    c = 0
    puts "ruby geoparse_record.rb  #{current.join(' ')}"
    current = []
  end
 
end

puts "ruby geoparse_record.rb  #{current.join(' ')}"
