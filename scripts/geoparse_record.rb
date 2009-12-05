#!/usr/bin/env ../digitalnz/script/runner

include GeoparseRecordHelper



natlib_record_ids = ARGV

puts "GEOPARSING:#{natlib_record_ids}"

parse_natlib_records(natlib_record_ids)