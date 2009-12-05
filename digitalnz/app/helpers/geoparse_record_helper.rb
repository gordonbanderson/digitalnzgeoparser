#!/usr/bin/env ../digitalnz/script/runner
require 'placemaker'
require 'digest/md5'

include GeoParserHelper

require 'memcache'


module GeoparseRecordHelper




   def elapsed_time(message)
      elapsed = Time.now-$start_time
      puts "\tBRIEF:#{elapsed}:#{message}"
   end


   #Parse several records at once
   #@param natlib_record_ids An array of the Digital NZ record numbers
   #representing the records to be geoparsed
   def parse_natlib_records(natlib_record_ids)
      for natlib_record_id in natlib_record_ids
         parse_natlib_record natlib_record_id
      end
   end




   def parse_natlib_record(natlib_record_id)
      start_time = Time.now

      $start_time = Time.now
      puts "BRIEF:================"

      puts "ORIGINAL METATEXT FOR RECORD:#{natlib_record_id}\n===="
      nl = NatlibMetadata.find_by_natlib_id(natlib_record_id)

      #Grab the metadata if so necessary
      if nl.pending
         nl = NatlibMetadata.update_or_create_metadata_from_api(natlib_record_id)
      end

      elapsed_time("Trace 1")


      puts "========"
      puts nl.geo_text
      puts "========"

=begin
  puts geo_info.to_yaml
  puts geo_info.class

  r = geoparse_text(nl.geo_text)




  puts r[0].class
  puts r[0].keys

  for geo_search in r[0].keys
    n_places = geo_search.cached_geo_searches.length
    used = "USED:"
    used = "IGNORED" if geo_search.failed
    puts "#{used} #{geo_search.id} |#{geo_search.search_term}|\t#{n_places}"
    for search in geo_search.cached_geo_searches
      puts "\t#{search.accuracy.name} (#{search.latitude}, #{search.longitude})\t #{search.country}\t#{search.address}"
    end
  end

  puts r[1].to_yaml

=end



      puts "BRIEF:#{nl.natlib_id} - #{nl.title}"
      puts nl.geo_text

      geocoder_text = remove_non_geo_items_for_geocoders(nl.geo_text)
      elapsed_time("Trace 2")


      puts "TEXT FOR YAHOO\n======"
      puts geocoder_text[:yahoo]
      elapsed_time("Trace 3")

      puts "\nTEXT FOR GOOGLE\n======="
      puts geocoder_text[:google]
      elapsed_time("Trace 4")


      for word in geocoder_text[:removed]
         puts "REMOVED BY CALAIS: #{word}"
      end
      elapsed_time("Trace 5")

      puts geocoder_text[:calais_tags].to_yaml
      elapsed_time("Trace 6")

      original_calais_tags = geocoder_text[:calais_tags]
      removed_by_calais = geocoder_text[:removed]




      puts "YAHOO KEY:#{YAHOO_PLACEMAKER_KEY}"
      p = Placemaker::Client.new(:appid => YAHOO_PLACEMAKER_KEY, :document_content => geocoder_text[:yahoo], :document_type => 'text/plain')
      p.fetch!()
      elapsed_time("Trace 7 - just did yahoo placemaker call")

      #response = CACHE[memcache_key]


      google_places = geoparse_text(geocoder_text[:google])
      puts "BRIEF:== POTENTIAL PLACES FOUND =="
      for term in google_places[:geohits].keys
         puts "BRIEF: Potential place\t\t#{term.search_term}"
      end
      puts "\n"
      elapsed_time("Trace 8 - just geoparsed text")



      puts "RESULTS"
      puts p.to_yaml
      puts "/RESULTS"
      yahoo_place_names = {}

      puts "BRIEF: n YAHOO DOCS = #{p.documents.length}  (Should be 1)"
      for document in p.documents
         place_details = document.place_details
         admin_scope = document.administrative_scope
         geo_scope = document.geographic_scope
         extents = document.extents

         #YAHOO does not always return the correct bounding box.  As such stretch it if we have zero results

         if !extents.blank?
            northing_extent = extents.north_east.lat
            easting_extent = extents.north_east.lng
            westing_extent = extents.south_west.lng
            southing_extent = extents.south_west.lat
         else
            #The whole world
            northing_extent = 90
            easting_extent = 180
            westing_extent = -180
            southing_extent = -90
         end



         for place in place_details
            location = place.place
            westing_extent = location.centroid.lng if location.centroid.lng < westing_extent
            easting_extent = location.centroid.lng if location.centroid.lng > easting_extent
            northing_extent = location.centroid.lat if location.centroid.lat > northing_extent
            southing_extent = location.centroid.lat if location.centroid.lat < southing_extent
            # FIXME - TEST yahoo_place_names[location.name] = location.name
            puts "LOC (YAHOO):#{location.woe_id}\t#{location.name}\t#{location.location_type}\t#{location.centroid.lat}\t#{location.centroid.lng}\tWEIGHT=#{place.weight}\tCONFIDENCE=#{place.confidence}"
         end

         elapsed_time("Trace 9")


         if (!extents.blank?)
            puts "\nEXTENT #{extents.blank?}"
            puts "\tSW: #{extents.south_west.lat}, #{extents.south_west.lng}"
            puts "\tNE: #{extents.north_east.lat}, #{extents.north_east.lng}"


            puts
            puts "STRETCHED EXTENT"
            puts "\tSW:#{southing_extent}, #{westing_extent}"
            puts "\tNE: #{northing_extent}, #{easting_extent}"
         end

         if !geo_scope.blank?
            puts "========= GEOSCOPE"
            puts geo_scope.name
            puts geo_scope.woe_id
            puts geo_scope.location_type
            puts geo_scope.centroid.lat.to_s+","+geo_scope.centroid.lng.to_s
         end

         if !admin_scope.blank?
            puts "\nADMIN SCOPE"
            puts "\t#{admin_scope.name}"
         end





      end
      elapsed_time("Trace 10")

      #  puts geo_scope.centroid.class


      #Filter google geocoded locations by Yahoo placemaker boundary
      bounding_extent = nil
      if !extents.blank?
         bounding_extent = Extent::new
         bounding_extent.north = extents.north_east.lat
         bounding_extent.east = extents.north_east.lng
         bounding_extent.south = extents.south_west.lat
         bounding_extent.west = extents.south_west.lng
      end

      filtered = filter_google_results(place_details, admin_scope, geo_scope, bounding_extent, google_places )
      keepers = filtered[:keepers]
      google_placenames = {}
      for term in keepers
         p = term.cached_geo_search_term.search_term
         google_placenames[p]=p
      end

      elapsed_time("Trace 11")
      number_filtered_google_results = google_placenames.keys.size
      puts "BRIEF: NUMBER OF GOOGLE PLACENAMES INSIDE YAHOO BOUNDARY:#{number_filtered_google_results}"

      #If we have no results the yahoo boundary may be incorrect.  Extend it and try again
      if number_filtered_google_results == 0
         stretched_extent = Extent::new
         stretched_extent.west = westing_extent
         stretched_extent.east = easting_extent
         stretched_extent.north = northing_extent
         stretched_extent.south = southing_extent
         puts "Checking extended bounding box:"
         puts "\tSW:#{southing_extent}, #{westing_extent}"
         puts "\tNE: #{northing_extent}, #{easting_extent}"
         filtered = filter_google_results(place_details, admin_scope, geo_scope, stretched_extent, google_places )
         keepers = filtered[:keepers]
         google_placenames = {}
         for term in keepers
            p = term.cached_geo_search_term.search_term
            google_placenames[p]=p
         end

         puts "BRIEF: NUMBER OF GOOGLE PLACENAMES INSIDE STRETCHED YAHOO BOUNDARY:#{number_filtered_google_results}"

      end

      puts filtered[:zero_matches]
      for term in filtered[:zero_matches]
         puts "ZERO:#{term.search_term}"

      end

      elapsed_time("Trace 12")

      for word in filtered[:too_short]
         puts "SHORT:#{word}"
      end

      for word in filtered[:failed]
         puts "FAILED TO GEOCODE FUNCTION:#{word}"
      end

      for word in filtered[:stopped]
         puts "STOPWORD:#{word}"
      end

      #FIXME - Check functionality
      yahoo_string = ""
      puts "BREIF: YAHOO PLACE NAME KEYS ARE #{yahoo_place_names.keys.join(' | ')}"
      for name in yahoo_place_names.keys
         puts "BRIEF: Checking yahoo place name #{name} against list of google placenames found"

         if google_placenames[name].blank?
            yahoo_string << name
            yahoo_string << "\n\n"
            puts "\tBRIEF: No google match for #{name}, appending to yahoo string"
         else
            puts "\tBRIEF:Already found google match for #{name} but may have been rejected due to Yahoo bounding box"
         end
      end
      yahoo_keepers = []
      elapsed_time("Trace 13")
      puts "PARSING YAHOO INFO:#{yahoo_string}"

      if !yahoo_string.blank?
         puts "YAHOO"
         puts yahoo_string
         yahoo_google_places = geoparse_text(yahoo_string)
         elapsed_time("Trace 14")
         yahoo_keepers = filter_google_results(place_details, admin_scope, geo_scope, bounding_extent, yahoo_google_places )[:keepers]
      end


      puts "KEEPERS"
      keepers = keepers+yahoo_keepers
      keepers.flatten!

      #Now filter by distance from the centroid

      #Remove any current submission
      if !nl.submission.blank?
         #FIXME - tranasction
         #sql = "delete from filtered_phrases_submissions where submission_id = #{nl.submission.id}"
         #puts sql
         #ActiveRecord::Base.connection.execute(sql)

         nl.submission.filtered_phrases = []

         puts "AUDIT: Removing old submission of id #{nl.submission.id}"
         destroyed = nl.submission.destroy
         puts "BRIEF: AUDIT:#{destroyed}"
         elapsed_time("Trace 17a")

      end
      elapsed_time("Trace 17b - removed any previous submission")
      new_filtered_phrases = []

      puts nl.geo_text
      submission = Submission::new
      submission.body_of_text = nl.geo_text
      submission.signature = Digest::MD5.hexdigest(nl.geo_text)
      #submission.save!

      nl.submission = submission
      elapsed_time("Trace 18")

      puts
      if !geo_scope.blank?
         puts "GEOSCOPE"
         puts geo_scope.name
         puts geo_scope.location_type
         puts geo_scope.centroid.lat.to_s+","+geo_scope.centroid.lng.to_s
         centroid = Centroid::new
         centroid.latitude = geo_scope.centroid.lat
         centroid.longitude = geo_scope.centroid.lng
         centroid.extent_type = geo_scope.location_type
         centroid.save

         submission.centroid = centroid

         elapsed_time("Trace 19")
      end



      #submission.save!

      if !extents.blank?
         puts "\nEXTENT"
         puts "\tSW: #{extents.south_west.lat}, #{extents.south_west.lng}"
         puts "\tNE: #{extents.north_east.lat}, #{extents.north_east.lng}"
      end

      elapsed_time("Trace 20")

      if !extents.blank?
         extent = Extent::new
         extent.south = extents.south_west.lat
         extent.west = extents.south_west.lng
         extent.north = extents.north_east.lat
         extent.east = extents.north_east.lng
         extent.save

         submission.extent = extent
         #submission.save!
         elapsed_time("Trace 21")
      end


      submission_places = []
      for cached_place in keepers
         if centroid.blank?
            delta_from_centroid = distance_between_coordinates(0,
            0,
            cached_place.latitude,
            cached_place.longitude
            )
         else
            delta_from_centroid = distance_between_coordinates(geo_scope.centroid.lat,
            geo_scope.centroid.lng,
            cached_place.latitude,
            cached_place.longitude
            )
         end

         place_string = "\t#{cached_place.cached_geo_search_term.search_term}\t#{cached_place.country} - #{cached_place.accuracy.name} - '#{cached_place.address} - #{cached_place.latitude}, #{cached_place.longitude} - ' D:#{delta_from_centroid}"
         submission_places << cached_place
         puts place_string
      end

      elapsed_time("Trace 22")

      submission.cached_geo_searches = submission_places
      #submission.save!

      elapsed_time("Trace 23")
      #Other info
      puts "\nCALAIS TAGS"
      puts "===========\n"
      for calais_key in original_calais_tags.keys
         puts "KEY:#{calais_key}"
         for item in original_calais_tags[calais_key]
            puts "\tVALUE:"+item
         end
      end

      puts "\nSTOPPED WORDS"
      puts "============="
      filter_type = FilterType.find_by_name('stopped');
      for stopped_word in google_places[:stopped]
         p = Phrase.find_or_create(stopped_word)
         filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
         new_filtered_phrases << filtered_phrase
         puts "\tSTOPPED:#{stopped_word}"
      end

      elapsed_time("Trace 24")

      puts
      puts "\nREMOVED BY CALAIS"
      puts "================="
      filter_type = FilterType.find_by_name('filtered_by_calais');

      for item in removed_by_calais
         puts "\t#{item}"
         p = Phrase.find_or_create(item)
         filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
         new_filtered_phrases << filtered_phrase
      end

      elapsed_time("Trace 25")

      puts "\n\nTOO SHORT"
      puts "========="
      filter_type = FilterType.find_by_name('too_short');

      for item in google_places[:too_short]
         puts "\t#{item}"
         p = Phrase.find_or_create(item)
         filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
         new_filtered_phrases << filtered_phrase
      end

      elapsed_time("Trace 26")


      puts "\n\nGEOCODER FAILED"
      puts "========="
      filter_type = FilterType.find_by_name('geoparser_failed')
      for item in google_places[:failed]
         puts "\t#{item}"
         p = Phrase.find_or_create(item)
         filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
         new_filtered_phrases << filtered_phrase
      end

      elapsed_time("Trace 27")


      puts "\n\nTEXT ATTEMPTED THAT DID NOT MATCH"
      zero_matches = filtered[:zero_matches]
      filter_type = FilterType.find_by_name('no_geocoder_matches')
      for term in zero_matches
         words = term.search_term
         p = Phrase.find_or_create(words)
         filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
         new_filtered_phrases << filtered_phrase
         puts "ZERO:#{term.search_term}"

      end

      elapsed_time("Trace 28")

      puts "\n\nTEXT THAT GEOMATCHED OUTSIDE YAHOO REGION"
      outside_bounding_box = filtered[:outside_bounding_box]
      filter_type = FilterType.find_by_name('outside_bounding_box')

=begin
  FIXME - use join through table from cached geo searches to submission
    for term in outside_bounding_box
      words = term.search_term
      p = Phrase.find_or_create(words)
      filtered_phrase = FilteredPhrase.find_or_create(p, filter_type)
      new_filtered_phrases << filtered_phrase
      puts "OUTSIDE YAHOO BOUNDING BOX:#{term.search_term}"

    end
=end

      submission.filtered_phrases = new_filtered_phrases

      elapsed_time("Trace 29")

      #Record the original frequencies
      pfs = []
      for k in google_places[:geohits].keys
         phrase = Phrase.find_or_create(k.search_term)
         pf = PhraseFrequency::new
         pf.phrase = phrase
         pf.submission = submission
         pf.frequency = google_places[:geohits][k]
         puts "PF - setting submission to be #{submission} of id #{submission.id}"
         pfs << pf
      end

      elapsed_time("Trace 29a")

      PhraseFrequency.transaction do
         pfs.map{|pf| pf.save}
      end

      elapsed_time("Trace 29b")

      elapsed_time("Trace 29c")


      submission.save! #Save the whole shebang in one go

      puts "Have now saved submission"


      elapsed_time("Trace 30 - just saved phrase frequencies")
      submission.calculate_area
      puts "AREA:#{submission.area}"

      elapsed_time = Time.now-start_time
      puts "BREIF:#{submission.natlib_metadata.natlib_id} - #{submission.natlib_metadata.title}"
      puts "BRIEF:\t#{submission.id} - #{submission.natlib_metadata.natlib_id}  #{submission.cached_geo_searches.length} locations, area = #{submission.area} TIME=#{elapsed_time}"
      elapsed_time("Trace 31")
   end

   # puts sanitize_yahoo_results.to_yaml
end
