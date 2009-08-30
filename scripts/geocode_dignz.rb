#!/usr/bin/env ../digitalnz/script/runner
require 'digitalnz'
require 'digitalnz_helper'

include DigitalnzHelper

require 'calais_helper'

include CalaisHelper

record_number = ARGV[0]

puts "Getting metadata for record #{record_number}" #eg 68346
result = get_metadata(record_number)


puts "===================="
geostring = result['dc']['title']
geostring << "\n"
geostring << result['dc']['subject'].join("|") if !result['dc']['subject'].blank?


gg = GoogleGeocodeClient.new GOOGLE_MAPS_API_KEY

tags = get_tags(geostring)
for tag_key in tags.keys
  puts "TAG:"+tag_key
  puts "\tDATA: #{tags[tag_key]}"
end



puts "GEO:"+geostring

places = gg.locate(geostring)
puts places.to_yaml

=begin
has many:
identifier
subject Y
coverage Y
rights
categories
formats
relations
placenames (15000 is good example)


./script/generate resource natlib_metadata creator:string contributor:string date:date description:text language:string publisher:string title:string collection:string landing_url:string thumbnail_url:string format:string coverage:string type_id:integer content_partner:string
=end


