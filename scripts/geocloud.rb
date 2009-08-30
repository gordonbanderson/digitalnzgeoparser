#!/usr/bin/env ../digitalnz/script/runner
for cgs in CachedGeoSearchTerm.find(:all, :limit=>10000)
    puts cgs.search_term
    puts "http://geocoding.cloudmade.com/BC9A493B41014CAABB98F0471D759707/geocoding/find/#{cgs.search_term.gsub(' ','%20')}.js?results=1"
    puts
end