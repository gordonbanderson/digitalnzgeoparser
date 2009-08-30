#!/usr/bin/env ../digitalnz/script/runner
require 'digitalnz'
DigitalNZ.api_key = DIGITAL_NZ_KEY
search_term = ARGV[0]
puts search_term

query_hash = {}
query_hash[:search_text] = search_term
query_hash[:facets] = 'category,content_partner,creator,language,rights,century,decade,year'


search_result = DigitalNZ.search(query_hash)
#("search_text = #{search_term}&num_results_requested => 50")
for result in search_result.results
  puts "TITLE:#{result.title}"
  puts "DESCRIPTION:#{result.description}"
  puts "META:#{result.metadata.to_yaml}"
  puts
end

puts search_result.to_yaml

puts "----"
puts search_result.facets.to_yaml
asdfsfsdf

 puts "FACET:"+f.class.to_s
  for key in f.keys
    puts "\tKEY:#{key}"
    puts "\t\t"+f[key].class.to_s
    for item in f[key]
      puts "\t\t\t#{item}, #{item.class}"
    end
  end
  
  