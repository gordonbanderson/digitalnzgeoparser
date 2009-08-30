#!/usr/bin/env ../digitalnz/script/runner
include GeoParserHelper
text = ARGV.join(' ')
geo_info = geoparse_text(text)

puts geo_info.class
