#!/usr/bin/env ../digitalnz/script/runner

require 'calais_helper'
require 'google_geocode_json_client'
require 'memcache'

include NatlibMetadatasHelper


query = ARGV.join ' '

puts "Searching for #{query}"


facet_filters = {
    "category" => "Images",
    "content_partner" => '"Alexander Turnbull Library"'
    
    #content_partner:"Alexander Turnbull Library
}


populate_from_search(query, facet_filters, 100,4000, true)

=begin
for query in [
    "beach",
    "bay",
    "coastline",
    "forest",
    "cliffs",
    "shore",
    "mount"
    
   "Wellington",
   "Auckland",
   "Whangarei",
   "Rotorua",
      "Tauranga",
         "Cape Reinga",
   "Napier",
   "Castlepoint",
   "New Plymouth",
   "Taranaki",
   "Ohakune",
   "Kapiti",
   "Palmerston North",
   "Dannevirke",
   "Cape Palliser",
   
   "Picton",
   "Nelson",
   "Marlborough Sounds",
   "Blenheim",
   "Christchurch",
   "Dunedin",
   "Kaikoura",
   "Invercargill" 
]
populate_from_search(query, facet_filters, 100,4000, true)
end

=end