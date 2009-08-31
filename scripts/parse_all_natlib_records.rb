#!/usr/bin/env ../digitalnz/script/runner

for nl in NatlibMetadata.find(:all, :order => 'id desc')
  puts "ruby geoparse_record.rb  #{nl.natlib_id}"
end