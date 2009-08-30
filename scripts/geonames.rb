require 'rubygems'
require 'geonames'
places_nearby = Geonames::WebService.find_nearby_place_name 43.900120387, -78.882869834
p places_nearby