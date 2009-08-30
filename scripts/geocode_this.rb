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

result = gg.geocode(address, CACHE)
puts "\n\n\n\n\n\n\n\n\n"
puts "++++++++++++++++++"
puts "\n"
puts result.to_yaml

=begin
bbox_west: 
bbox_east: 
bbox_south: 
bbox_north: 
=end