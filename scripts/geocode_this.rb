#!/usr/bin/env ../digitalnz/script/runner

require 'calais_helper'
require 'google_geocode_json_client'
require 'memcache'


include CalaisHelper
include GoogleGeocodeHelper

address = ARGV.join(' ')

gg = GoogleGeocodeJsonClient.new GOOGLE_MAPS_API_KEY
#gg.set_viewport_bias(164.9268, -48.3124,180.0, -34.1118 )
gg.set_country_bias('nz')


puts "'#{address}'"

puts CACHE.methods.sort
puts CACHE.stats.to_yaml
puts CACHE.flush_all
puts CACHE.stats.to_yaml



result = gg.geocode(address)#, CACHE)
puts "\n\n\n\n\n\n\n\n\n"
puts "++++++++++++++++++"
puts "\n"
puts result.to_yaml
puts result.class

puts result.keys.to_yaml

puts "STATUS:"+result[:status_code].to_s
puts "SEARCH TERM:"+result[:search_term].to_s
puts "LOCATIONS:"
=begin
- !ruby/struct:Location 
  address: Minister, PA 16347, USA
  latitude: 41.6189504
  longitude: -79.1483752
  country: USA
  admin_area: PA
  subadmin_area: Forest
  locality: Minister
  dependent_locality: 
  accuracy: 4
  name: Minister
  status_code: 200
  bbox_west: -79.1643826
  bbox_east: -79.1323678
  bbox_south: 41.6106084
  bbox_north: 41.6272913
=end

locations = result[:locations]
puts "LOCATIONS FOUND:#{locations.size}"
for location in locations
    puts location.address
    puts "\t#{location.latitude},#{location.longitude}"
    puts "\t#{location.name}"
end

=begin
bbox_west: 
bbox_east: 
bbox_south: 
bbox_north: 
=end