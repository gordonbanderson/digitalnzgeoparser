require 'rubygems'
require 'yaml'
require 'placemaker'

module GeoParserHelper
  
  include GeographyHelper
  include CalaisHelper
  
  
  @position_words = ['in']
  
  

  
  
  def geoparse_text(text)
      #Some abbreviations may cause sentence splits - if they do add the last word from the previous sentence to the current one
      abbrevidation_exceptions = ['mt']
      
    countries = []
    #puts "Parsing text"
    geoparsed_info = possible_place_names(text)
    name_freq = geoparsed_info[:possible_place_names]
    calais_tags = geoparsed_info[:calais_tags]
    names = name_freq.keys.sort
    
    #puts "NAMES EXTRACTED"
    geohits = {}
    too_short = []
    stopped = []
    failed = []
    
    for name in names
      #puts "Parsing:#{name}"
      puts "AUDIT: CHECKING - #{name}  (#{name.length})"
      
      #Check for too short - might occur with say M.Ellis splitting to an M character
      if name.length < 3
        puts "\tAUDIT: TOO SHORT - '#{name}'"
        if !abbrevidation_exceptions.include? name.downcase
            too_short << name 
        else
            puts "AUDIT: TOO SHORT - REPRIEVED '#{name.downcase}' as in exceptions list"            
            
        end
      elsif !StopWord.find_by_word(name.downcase).blank?
        puts "\tAUDIT: STOPPED - #{name}"
        stopped << name
      else
        
        puts "AUDIT: Searching for #{name}"
        cached_search_term = parse_address(name)
        if cached_search_term.is_country?
          countries << cached_search_term
        end
        
        #Ignore fails
        if !cached_search_term.failed
          puts "AUDIT: Saving #{cached_search_term.search_term} with #{cached_search_term.cached_geo_searches.length} locations"
          geohits[cached_search_term] = name_freq[cached_search_term.search_term]
          
        else
          puts "AUDIT: Search failed - #{cached_search_term.search_term}"
          failed << name
        end
      end
    end
    
    puts geohits.to_yaml
    
=begin
    #For each search term, append each country to it
    existing_searches = geohits.keys
    for search_term in existing_searches
      
      #Dont search with stop words
      stop_word = StopWord.find_by_word(search_term.search_term.downcase)
      RAILS_DEFAULT_LOGGER.debug "STOP WORD IS #{stop_word}"
      if !stop_word.blank?
        RAILS_DEFAULT_LOGGER.debug "STOP WORD IS #{stop_word.word}"
      end
      if !countries.include?(search_term) && stop_word.blank?
        for country_search_term in countries
          #We may have search terms that are not countries
          for cgs in country_search_term.cached_geo_searches
            if cgs.is_country?
            abbrev = cgs.country
              country = Country.find_by_abbreviation(abbrev)
              if !country.blank?
                for name in country.country_names
                  new_search_term = search_term.search_term+", "+name.name
                  #puts "** CREATING COUNTRY NEW SEARCH #{new_search_term}"
                  cached_search_term = parse_address(new_search_term, create_alternative_country_names=false)
                
                  #Check if we have an exact match, otherwise it gets too noisy
                  for s in cached_search_term.cached_geo_searches
                    if s.address == new_search_term
                      #puts "** MATCH FOUND #{new_search_term}"
                      geohits[cached_search_term] = 0
                    end
                  end
                 
                    #  
                  021 
                end
              else
                  RAILS_DEFAULT_LOGGER.debug "Blank country found for #{abbrev}"
              end
            end
          end
        end
      end
    end
=end


    #Second pass
    singular_hits = {}
    
    #puts geohits.to_yaml
    #puts geohits.class
    
    
    for cached_geo_search_term in geohits.keys
      puts "AUDITING:#{cached_geo_search_term.search_term}"

      n_hits = cached_geo_search_term.cached_geo_searches.length
      
      #This means we got an accurate hit - review nummber after testing
      if n_hits == 1
        accuracy = cached_geo_search_term.cached_geo_searches[0].accuracy.name
        if !singular_hits[accuracy].blank?
          singular_hits[accuracy] << cached_geo_search_term
        else
          singular_hits[accuracy] = [cached_geo_search_term]
        end 
      end
    end
    
    #puts "====== singular hits ====="
    #puts singular_hits.keys.to_yaml
    
    countries = singular_hits['Country']
    regions = singular_hits['Regional']
    subregions = singular_hits['Sub Region']
    towns = singular_hits['Town']
    post_codes = singular_hits['Town']
    streets = singular_hits['Street']
    
    #puts "TOWNS:#{towns.to_yaml}"
    
    
    
    puts "CALAIS TAGS:"
    puts calais_tags.to_yaml
    
    puts "WORDS:"
    puts geohits.to_yaml
    
    
=begin
geohits = {}
too_short = []
stopped = []
failed = []
=end
  #  [geohits, calais_tags]
   {
     :geohits => geohits,
     :calais_tags => calais_tags,
     :too_short => too_short,
     :stopped => stopped,
     :failed => failed
   }
   
    
    
    
  end
  
  #Collate all the words with capital letters or sequences of words with capital letters
  def possible_place_names(text)
      #Some abbreviations may cause sentence splits - if they do add the last word from the previous sentence to the current one
      abbrevidation_exceptions = ['mt']
      
    #Use the open calais service to help filter
    calias_tags = get_cached_tags(text)
    #puts calias_tags.to_yaml
    

    
    possible_place_names = {}
    current_cap_words="" #This will hold a stream of cap words, e.g. "New Zealand"
    
    last_was_bankable = false
    
    #FIXME - fix paragraph breaks
    paragraphs = text.split("\n\n")
    original_word=''
    for paragraph in paragraphs
        puts "\n\nNEW PARAGRAPH"
        puts "++++++++++++++\n\n"
      #puts "\n\n\n\nPARA:"
      #We now have paragraphs so split them into sentences - then we can look at words with capital letters
       sentences = paragraph.split("\. ")
        for sentence in sentences
            #prefix sentence with an abbreviation if so require, e.g. Mt. Christina gets split on Mt.
            if abbrevidation_exceptions.include?(original_word.downcase)
               sentence = original_word+'. '+sentence 
            end
            puts "\n\nNEW SENTENCE, last word was #{original_word}"
            puts "++++++++++++++\n\n"
          current_cap_words='' #Reset for start of a sentence
          words = sentence.split(" ")
          for word in words
            original_word = word.clone
            puts "WORD PRE CLEAN:#{word}"
            #puts "WORD.class:#{word.class}"
            word.gsub!("'s", "")
            #puts "NO APOSTROPHE:#{word}"

  
            word.gsub!(/\W/, ' ') # Remove non letters and numbers
            word.gsub!(/\d/, ' ') # Remove numbers
            word.gsub!(/\_/, ' ') # Remove underscore
            word.gsub!(/\‘‘/,'') # Remove apostrophes
            word.gsub!(/\“/,'') # Remove msoft apostrophe
            word.gsub!(/\“/,'') # Remove msoft apostrophethe Robuller
            word.gsub!(/\‘/,'')
            word.gsub!(/\’/,'') 
            word.gsub!('&#8220','')
            word.gsub!('&#8221','')
            word.strip!
            
            w_strip = word
            puts "STRIPPED WORD:#{w_strip}"
            
            last_char = word[-1,1]
            puts "\tWORD POST CLEAN:#{word}"
            
            first_letter = word[0,1]
            
            #Check for numbers
            numeric = false

            numeric = true if word.to_i.to_s == word #Find a better way to check this
            puts "\tLAST CHAR:#{last_char}"
            
            #If the word is blank we need to move on to the next one
            if word.blank?
              puts "SKIPPY, orig was #{original_word}"
              last_was_bankable = false
              current_cap_words = ''
              next
            end
            
            phrase_end = PHRASE_ENDERS.include?(last_char)
            
            puts "PHRASE END:#{phrase_end}"
            
            #puts "WORD #{word} is numeric? #{numeric}"
            precaps = (first_letter.upcase == first_letter)
            puts "WORD #{word} is CAPS: #{precaps}"
            
            trailing_char = ' '
            trailing_char = ', ' if original_word.ends_with?(',')
            current_cap_words << word+trailing_char if precaps && !numeric
            puts "WORD,ORIG=#{word} | #{original_word}"
            

   
            
            #puts "TRACE: Checking if *#{current_cap_words.strip}* is in #{calias_tags["Person"].join(',')}"
            
            #puts "TRACE 0: Calais filtered #{current_cap_words}" if filtered_by_calais == true
            #print "TRACE 0.4: NOT Calais filtered #{current_cap_words}" if filtered_by_calais == false
           
            
            
            #Is the current word bankable, ie passes conditions to be added 
            bank_current_caps_word = (!precaps || numeric || phrase_end)

            puts "CCW:#{current_cap_words} BANKABLE=#{bank_current_caps_word}, LASTWASBANKABLE=#{last_was_bankable}, WORD:#{word} !PC=#{!precaps} NUMERIC=#{numeric} PE=#{phrase_end} " #!FC=#{!filtered_by_calais}"
            
            #Do we have a condition that means the current caps word can be banked
            #ie small letter start of a number or a das
            if bank_current_caps_word
              
              #Now check for the 'The Baghdad' condition, ie starting with The<space>
              if current_cap_words.starts_with?("The ")
                current_cap_words = current_cap_words[4,current_cap_words.length] #this crops automagically
              end

              current_cap_words.strip!
              if !current_cap_words.blank?
                last_names = []
                if !calias_tags["Person"].blank?
                  last_names = calias_tags["Person"].map{|p|p.split(' ').last}
                end
                
                filtered_by_calais = false
                for category in [ "Company", "Person", "SportsEvent", "Product"]
                  if !calias_tags[category].blank?
                    #This does not work, dunno why - filtered_by_calais = true if calias_tags[category].include?(current_cap_words)
                    for item in calias_tags[category]
                      ##puts "CHECKING:*#{item}* == *#{current_cap_words}*"
                      if item == current_cap_words
                        filtered_by_calais = true
                        break;
                      end
                    end
=begin                    
                    if current_cap_words == 'XL Airways'
                      #puts "REUTERS:filtered_by_calais = #{filtered_by_calais}"
                      for tag in  calias_tags["Company"]
                        #puts "Comparing *#{current_cap_words}* (#{current_cap_words.class}) with TAG:*#{tag}* (#{tag.class})  EQUAL?#{current_cap_words == tag}"
                      end
                      
                      #puts "In array?: calias_tags[category].include?(current_cap_words)=#{calias_tags[category].include?(current_cap_words)}"
                      
                      
                      
                    end
=end
                    break #No need to check more
                  end
                end
                
                normed_cap_word = current_cap_words
                normed_cap_word.gsub!('Mr ', '')
                filtered_by_calais = true if last_names.include?(normed_cap_word)
                
                #puts "CALAIS: Checking #{current_cap_words}, and its #{filtered_by_calais}"
                long_enough = (current_cap_words.length > 2)
                if !filtered_by_calais && long_enough
                  current_cap_words = geo_clean(current_cap_words)
                  puts "ADDED: [T1] #{current_cap_words}"
                  possible_place_names[current_cap_words] = 0 if possible_place_names[current_cap_words].blank?
                  possible_place_names[current_cap_words] = possible_place_names[current_cap_words] + 1
                end
              end
              
              #Now check for countries, making special cases as appropriate
=begin
              if ![ "New South Wales"].include?(current_cap_words.strip)
                splits = current_cap_words.split(' ')
                if splits.length > 1
                  for split in splits
                    if !CountryName.find_by_name(split).blank?
                      #puts "TRACE2:Adding #{current_cap_words}"
                      possible_place_names[split] = 0 if possible_place_names[split].blank?
                      possible_place_names[split] = possible_place_names[split] + 1
                    end
                  end
                end
              end
=end
              current_cap_words = ''
            end
            last_was_bankable = bank_current_caps_word
            #puts "WORD:#{word}"
          end
          
          current_cap_words.strip!
          if !current_cap_words.blank?
            current_cap_words = geo_clean(current_cap_words)
            puts "ADDED: [T2] #{current_cap_words}, LAST WAS BANKABLE IS #{last_was_bankable}"
            possible_place_names[current_cap_words] = 0 if possible_place_names[current_cap_words].blank?
            possible_place_names[current_cap_words] = possible_place_names[current_cap_words] + 1
            
          end
        end
    end
    
    
    #Now make use of the calais data to try further search terms
    if !calias_tags["Country"].blank?
      for country in calias_tags["Country"]
        
        #Only add the country if its news
        if possible_place_names[country].blank?
          possible_place_names[country] = 0
        end
      end
    end
    
    #Now add facilities
    cities = calias_tags["City"]
    countries = calias_tags["Country"]
    if !calias_tags["Facility"].blank?
      for facility in calias_tags["Facility"]
        if !cities.blank?
          for city in cities 
            geoname = geo_clean("#{facility}, #{city}")
            puts "ADDED: [T3] #{current_cap_words}"
            
            possible_place_names[geoname]= 1 if possible_place_names[geoname].blank?
          end
          
        end
        
      end
    end
    

    #puts possible_place_names.to_yaml
    #puts possible_place_names.class
    if !calias_tags['NaturalFeature'].blank?
      for nf in calias_tags['NaturalFeature'] 
        #puts "Adding #{nf}"
        frequency = text.split(nf).length - 1
        place = geo_clean(nf)
        
        #This may overwrite an existing entry
        puts "ADDED: [T4] #{current_cap_words}"
        
        possible_place_names[place] = frequency
      end
    end
    
    
    #now delete crud
    possible_place_names.delete 'Dee' #This geocodes to Germany!
    possible_place_names.delete 'Tay' #And this to vietnam
    
    {
      :possible_place_names => possible_place_names,
      :calais_tags => calias_tags
    }
    #[possible_place_names,calias_tags] #Return an array of cap words to frequency, and the calais tags
  end
  
  
  #Clean out terms that do not help
  def geo_clean(le_word)
    result = le_word.gsub("Streets", "Street")
    result.gsub!(' N Z', ' NZ') # due N.Z. getting dots stripped
    result.gsub!('terminus', '')
    result.gsub!('Pembroke Perrow Series','')
    result.gsub!('&#8220','')
    result.gsub!('&#8221','')
    if result.ends_with?(',') 
      result[-1]=" "
      result.strip!
    end
    
    #puts "CLEANED:#{le_word} -> #{result}"
    result
  end
  
  
  #Filter out google results using yahoo results
  #This returns all the google geocoder results that fall within the specified extent
  #@param place details - hash from the geo parser method
  def filter_google_results(place_details, admin_scope, geo_scope, bounding_extent, google_places )
    if bounding_extent.blank?
      extent_string = "The whole world!"
    else
      extent_string = "SW(#{bounding_extent.south}, #{bounding_extent.west})->NE(#{bounding_extent.north}, #{bounding_extent.east})"
    end
    
    attempted_places = {}
    zero_matches = []
    outside_bounds = []
    keepers = []
    filtered_locations = []
    for google_place in google_places[:geohits]
      #puts google_place.class.to_s+" - #{google_place.length}"
      term = google_place[0]
      puts "\t#{term.class} - #{term.search_term}"
      cached_searches = term.cached_geo_searches
      zero_matches << term if cached_searches.length == 0
      for cached_place in cached_searches
        keep = false
        if bounding_extent.blank?
          keep = true #the whole world as we have no filter
        else
          check1 = cached_place.longitude >= bounding_extent.west
          check2 = cached_place.longitude <= bounding_extent.east
          check3 = cached_place.latitude <= bounding_extent.north
          check4 = cached_place.latitude >= bounding_extent.south
          keep = (check1 && check2 && check3 && check4)
          keepstring = "Is (#{cached_place.latitude}, #{cached_place.longitude}) inside of "
          keepstring << "SW:(#{bounding_extent.south}, #{bounding_extent.west})"
          keepstring << "to NE:(#{bounding_extent.north}, #{bounding_extent.east})?  - "
          keepstring << "#{keep}"
        end

       # puts
      #  puts extent_string
       # puts "CHECKS:#{check1}, #{check2}, #{check3}, #{check4}"
       if !geo_scope.blank?
         delta_from_centroid = distance_between_coordinates(geo_scope.centroid.lat, 
                                                             geo_scope.centroid.lng,
                                                             cached_place.latitude,
                                                             cached_place.longitude
          )
       else
         delta_from_centroid = distance_between_coordinates(0,
                                                            0,
                                                            cached_place.latitude,
                                                            cached_place.longitude
          )
       end
       

       attempted_places[cached_place.address]
       place_string = "\t\t#{cached_place.country} - #{cached_place.accuracy.name} - '#{cached_place.address} - #{cached_place.latitude}, #{cached_place.longitude} - ' D:#{delta_from_centroid}"

        if (
            keep
          ) 
            keep = true
            puts "KEEP: #{place_string}"+ "  (#{keepers.length})"
    
            filtered_locations << cached_place
        else
          puts "FILTERING OUT:#{place_string} of CLASS #{cached_place.class} [#{keepstring}]"
          outside_bounds << cached_place
        end

      end
      
      
    end
    
    {:keepers => filtered_locations,
      :outside_bounding_box => outside_bounds,
      :zero_matches => zero_matches,
      :calais_tags => google_places[:calais_tag],
      :stopped => google_places[:stopped],
      :too_short => google_places[:too_short],
      :failed => google_places[:failed]
      }
  end
  
  
=begin
Person: 
- Sydney Charles Smith
City: 
- Newtown
- Wellington
Country: 
- New Zealand
Relations: 
- ""
Organization: 
- Wellington Hospital
- Wellington Public Hospital

=end


  #Lowercase things like peoples names and organisations that can cause noise with geo parsing, e.g. Sydney Charles Smith
  def remove_non_geo_items_for_geocoders(text)
    
    result = text.clone
    
    removed = []
    
    #Remove text that might mislead the geoparsing process
#    result.gsub!('Horowhenua Historical Society Inc.', '')
#    result.gsub!('Alexander Turnbull Library,', '')
    
    
    puts "FILTERING\n========"
    result_for_google = result.clone
    result_for_yahoo = result.clone
    calais_tags = get_cached_tags(result)
    puts "CALAIS TAGS:"
    puts calais_tags.to_yaml
    

    #Remove non geographical keys from the text, e.g. we do not want to parse "Sydney Charles Smyth" when he is a person
    for key_non_geo in ['Person', 'Organization']
      #puts "NON GEO KEY:#{key_non_geo}"
      items = calais_tags[key_non_geo]
      if !items.blank?
        for item in calais_tags[key_non_geo]
          puts "REMOVING FROM GEO SEARCH:#{item}"
          result_for_google.gsub!(item, item.downcase)
          result_for_yahoo.gsub!(item, '')
          removed << item
        end
      else
        #puts "No non geo items of type #{key_non_geo}"
      end
    end
    
    puts
    puts
    
    {
      :yahoo => result_for_yahoo,
      :google => result_for_google,
      :calais_tags => calais_tags,
      :removed => removed
    }
  end
  
  
  

=begin
for document in p.documents
  place_details = document.place_details
  admin_scope = document.administrative_scope
  geo_scope = document.geographic_scope
  extents = document.extents

  for place in place_details
    location = place.place
    puts "LOC:#{location.woe_id}\t#{location.name}\t#{location.location_type}\t#{location.centroid.lat}\t#{location.centroid.lng}\tWEIGHT=#{place.weight}\tCONFIDENCE=#{place.confidence}"
  end

  puts "\nEXTENT"
  puts "\tSW: #{extents.south_west.lat}, #{extents.south_west.lng}"
  puts "\tNE: #{extents.north_east.lat}, #{extents.north_east.lng}"

  puts "\GEO SCOPE"
  puts "\t#{geo_scope.name}"

  puts "\nADMIN SCOPE"
  puts "\t#{admin_scope.name}"

  puts "========= GEOSCOPE"
  puts geo_scope.name
  puts geo_scope.woe_id
  puts geo_scope.location_type
  puts geo_scope.centroid.lat.to_s+","+geo_scope.centroid.lng.to_s
end
=end
  
  def sanitize_yahoo_results(placemaker_results)
    raise ArgumentError if placemaker_results.documents.length > 1
    result = []
    for document in placemaker_results.documents
      
    end
    result
  end
  
  
  def distance_between_coordinates(lat1, lon1, lat2, lon2)
    delta_lat = ([lat1,lat2].max-[lat1,lat2].max).abs
    delta_lon = ([lon1, lon2].max - [lon1, lon2].min).abs
    Math.sqrt(delta_lat*delta_lat + delta_lon*delta_lon)
  end
  
  
  def load_text(filename)
    text = ""
    File.open(filename, "r") do |infile|
      while (line = infile.gets)
         text << line
      end
    end
    text
  end
end