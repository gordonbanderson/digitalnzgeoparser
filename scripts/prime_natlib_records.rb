#!/usr/bin/env ../digitalnz/script/runner

require 'calais_helper'
require 'google_geocode_json_client'
require 'memcache'

include NatlibMetadatasHelper

=begin

facet_filters = {
    "category" => "Images",
    "content_partner" => '"Wairarapa Archive"'
    
    #content_partner:"Alexander Turnbull Library
}

populate_from_search("", facet_filters, 100,2000, true)

=end

#Now get images from the Alexander Turnbull collection for a shed load of items
facet_filters = {
    "category" => "Images",
    "content_partner" => '"Alexander Turnbull Library"'
    
    #content_partner:"Alexander Turnbull Library
}




for query in [
    "beach",
    "bay",
    "coastline",
    "forest",
    "cliffs",
    "shore",
    "mount",
    "shipwreck",
    "lighthouse",
    "road",
    "street",
    "island",
    
    "Pencarrow",
    
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
puts "Searching for #{query}"
populate_from_search(query, facet_filters, 100,1000, true)
end

