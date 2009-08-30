#!/usr/bin/env ../digitalnz/script/runner
require 'digitalnz'
require 'digitalnz_helper'

include DigitalnzHelper

record_number = ARGV[0]

puts "Getting metadata for record #{record_number}" #eg 68346
result = get_metadata(record_number)
puts result.to_yaml

metadata = NatlibMetadata::new
metadata.title = result['dc']['title']
metadata.creator = result['dc']['creator']
metadata.contributor = result['dc']['contributor']
metadata.language = result['dc']['language']
metadata.description = result['dc']['description']
metadata.publisher = result['dc']['publisher']


the_date = result['dc']['date']




if !the_date.blank?
  the_date.strip!
  the_date.gsub!('[','')
  the_date.gsub!(']','')
  start_date_string = the_date
  end_date_string = the_date
  begin
    if the_date.starts_with?("ca")
      the_date.gsub!("ca","").strip!
      metadata.circa_date = true
      start_date_string = the_date
      end_date_string = the_date
    else
      metadata.circa_date = false
    end
    
    if the_date.length == 4
      start_date_string = "1-1-"+the_date
      end_date_string = "31-12-"+the_date
      
    #Deal with a case like 1930s
    elsif the_date.length == 5 && the_date.ends_with?('s')
      year = the_date.gsub('s','').strip
      start_date_string = "1-1-#{year}"
      end_date_string = "31-12-#{year.to_i+9}"
    end
    
    start_date = Time.parse(start_date_string)
    end_date = Time.parse(end_date_string)
    metadata.start_date = start_date
    metadata.end_date = end_date
    
  rescue Exception => e
    puts "FAILED TO PARSE DATE:#{the_date}"
    puts e.to_yaml
  end
end

dc_type = result['dc']['type']
if !dc_type.blank?
  tipe = Tipe.find_by_name(dc_type)
  if tipe.blank?
    tipe = Tipe::new
    tipe.name = dc_type
    tipe.save!
  end
  metadata.tipe = tipe
end

metadata.thumbnail_url = result['dnz']['thumbnail_url']
metadata.landing_url = result['dnz']['landing_url']
metadata.collection = result['dnz']['collection']
metadata.content_partner = result['dnz']['content_partner']

#Subjects
subjects = result['dc']['subject']
if !subjects.blank?
  for subject in subjects
    s = Subject::new
    s.name = subject
    s.natlib_metadata = metadata
    s.save!
  end
end

#Coverages
coverages = result['dc']['coverage']
if !coverages.blank?
  for coverage in coverages 
    c = Coverage::new
    c.name = coverage
    c.natlib_metadata = metadata
    c.save!
  end
end

#Placenames
placenames = result['dnz']['placename']
if !placenames.blank?
  for placename in placenames
    o = Placename::new
    o.name = placename
    o.natlib_metadata = metadata
    o.save!
  end
end


#Rights
formats = result['dc']['format']
if !formats.blank?
  for format in formats
    o = Format::new
    o.name = format
    o.natlib_metadata = metadata
    o.save!
  end
end

#Relations
things = result['dc']['relation']
if !things.blank?
  for name in things
    o = Relation::new
    o.name = name
    o.natlib_metadata = metadata
    o.save!
  end
end

#Identifiers
things = result['dc']['identifier']
if !things.blank?
  for name in things
    o = Identifier::new
    o.name = name
    o.natlib_metadata = metadata
    o.save!
  end
end

metadata.save!