#!/usr/bin/env ../digitalnz/script/runner
require 'geokit'

g1 = CachedGeoSearch.find(:first)
puts g1

g2 = CachedGeoSearch.find(588)
puts g2

puts g2.to_yaml

n = 30
puts "\nWITHIN #{n} km"

for cgs in CachedGeoSearch.find(:all, :origin => g2, :within => n)
  puts "#{cgs.id} - #{cgs.address}\n"
  puts g2.distance_to(cgs)
  puts "\n\n"
end