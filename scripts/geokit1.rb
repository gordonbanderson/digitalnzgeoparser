#!/usr/bin/env ../digitalnz/script/runner
require 'geokit'
puts "YAHOO"
puts "====="
y=Geokit::Geocoders::YahooGeocoder.geocode ARGV.join ' '
puts y

puts "\n\nGOOGLE"
puts "======"
g=Geokit::Geocoders::GoogleGeocoder.geocode ARGV.join ' '
puts g

puts "N MATCHES:"+g.all.size.to_s
g.all.each { |e| puts e.full_address }


puts g.distance_to(y).to_s+'km apart'

puts "\nIP GEOCODER"
puts "==========="
location = Geokit::Geocoders::IpGeocoder.geocode('202.175.135.91')
puts location

=begin
puts "\n\nGEONAMES"
puts "======"
a=Geokit::Geocoders::GeonamesGeocoder.geocode ARGV.join ' '
puts "popopp"
puts a
=end
puts "\nGOOGLE REVERSE GEOCODE"
puts "\n======================="
puts g.ll

res=Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{g.ll}"
puts res.full_address




