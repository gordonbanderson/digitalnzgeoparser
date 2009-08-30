#!/usr/bin/env ../digitalnz/script/runner

for nl in NatlibMetadata.find(:all, :order => 'id desc')
  puts "ruby show_geo_text.rb  #{nl.natlib_id}"
end