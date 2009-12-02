require 'rubygems'
require 'google_geocode_client'
require 'yaml'
require 'memcache'
  
module GeographyHelper
  
  

  def parse_address(geo_search_term, country_bias='nz', create_alternative_country_names=true)
    
    #Search for a cached entry first
    search_term = geo_search_term.strip #Remove spaces
    puts "SEARCH TERM:*#{search_term}*, create_alternative_country_names=#{create_alternative_country_names}"
    cached_search_term = CachedGeoSearchTerm.find_by_search_term(search_term)
    
    puts "CACHED SEARCH TERM:#{cached_search_term.to_yaml}"
    
    gg = GoogleGeocodeJsonClient.new GOOGLE_MAPS_API_KEY
    gg.set_country_bias(country_bias) if !country_bias.blank?
    puts "CACHE:#{CACHE}"

    if cached_search_term.blank?
      
      
      cached_search_term = CachedGeoSearchTerm::new
      cached_search_term.search_term = search_term
      cached_search_term.failed = false
      
      cached_search_term.is_country = false
      cached_search_term.save! #Throw an exception if the save does not work

      geocode_result = gg.geocode geo_search_term, CACHE
      locations = geocode_result[:locations]
      
      puts "ST:#{geo_search_term}, LOCS:#{locations.length}"
      
      puts geocode_result.to_yaml
      puts geocode_result.class
      
      
      if geocode_result[:status_code].to_i == 200
        
        
      
        for location in geocode_result[:locations]
        
        
          cached = CachedGeoSearch::new
          cached.latitude = location.latitude
          cached.longitude =  location.longitude
          cached.bbox_west = location.bbox_west
          cached.bbox_east = location.bbox_east
          cached.bbox_south = location.bbox_south
          cached.bbox_north = location.bbox_north
          
          
          cached.country =  location.country
          cached.admin_area =  location.admin_area
          cached.subadmin_area =  location.subadmin_area          
          cached.locality =  location.locality
          cached.dependent_locality =  location.dependent_locality
     
        
          accuracy_number = location.accuracy
          puts "ACCURACY IS #{accuracy_number}"
          accuracy = Accuracy.find_by_google_id(accuracy_number)

            
        
          raise ArgumentError if accuracy.blank?

        
          cached.accuracy = accuracy
          cached.address = location.address
        
          cached.cached_geo_search_term = cached_search_term
        

  
        
        
          begin
            puts "Search term object is #{cached.cached_geo_search_term}"
            #puts cached.to_yaml
            cached.save!
          rescue Exception => e
             puts "TRACE1 - #{search_term}"
             puts "Unable to save #{search_term}, db issue?"
             puts "Exception: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
             puts "========="
          end
 
 
 
          

        
            #Look for country matches
            puts "**** CHECKING COUNTRY MATCHES"
            for cached_search in cached_search_term.cached_geo_searches
        

              puts "GH:LOCS #{search_term} cached accuracy is #{cached_search.accuracy.name}, #{accuracy.id}"
              #First we check if the country already exists, otherwise we use the google name
              existing_country_name = CountryName.find_by_name(cached_search_term.search_term)
              puts "LOCS: existing country from #{search_term} is #{existing_country_name}"
            
            
            
              if !existing_country_name.blank?
                cached_search_term.is_country = true
                cached_search_term.save!
              else
              
                if cached_search.accuracy.id == Accuracy::COUNTRY.id
                  cached_search_term.is_country = true
                  cached_search_term.save!
     
                  if create_alternative_country_names == true
                    #Now we need to create a country - possibly
                    country_name = cached_search.cached_geo_search_term.search_term
                    puts "COUNTRY NAME IS #{country_name}"
                    the_country_name = CountryName.find_by_name(country_name)
                    puts "THE COUNTRY NAME IS BLANK? #{the_country_name.blank?}"
                
                    if the_country_name.blank?
                      puts "CREATING COUNTRY NAME OBJECT FOR #{country_name}, address #{cached_search.address}, #{create_alternative_country_names}"
                      the_country_name = CountryName::new
                      the_country_name.name = country_name
                      the_country = Country::find_by_abbreviation(cached_search.country)
                      the_country_name.country = the_country
                      the_country_name.save!
                      break
                    end
                  end
                else
                  puts "#{search_term} is not a LOCS country"
                end
              end
            end
        
        

        end
      
      else
        puts "AUDIT: Search returned an error by google"
      end
    else
      puts "AUDIT:ALREADY CACHED:#{cached_search_term.search_term}"
    end
    return cached_search_term
  end
  
  
  
  
  


end
