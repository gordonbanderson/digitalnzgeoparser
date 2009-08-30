#!/usr/bin/env ../digitalnz/script/runner
require 'calais_helper'

include CalaisHelper

file = ARGV[0]

puts "Parsing #{file}"

text=''

ctr = 0

f = File.new(file, "r")
  while (line = f.gets)
    #puts ctr
    #puts line
    ctr = ctr + 1
    text << line if line != nil
  end


puts text
tags = get_cached_tags(text)
puts "FROM CACHED TAGS:"
puts tags.to_yaml

for tag_key in tags.keys
  puts '--'
  puts tag_key
  for tagged_result in tags[tag_key]
    puts "\t#{tagged_result}"
  end
end