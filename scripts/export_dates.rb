#!/usr/bin/env ../digitalnz/script/runner
puts "begin;"
for nl in NatlibMetadata.find(:all, :conditions =>["start_date is not null"])
  puts "insert into record_dates(start_date, end_date, natlib_metadata_id)"
  puts "values ('#{nl.start_date}', '#{nl.end_date}', #{nl.id});"
  puts
end
puts "commit;"