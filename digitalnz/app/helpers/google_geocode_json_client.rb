require('rubygems')
require('net/http')
require('uri')
require('json')
require('cgi')
require 'memcache'
require 'digest/sha2'


##
# Library for looking up coordinates with Google's Geocoding API.
#

#

# http://www.google.com/apis/maps/documentation/#Geocoding_HTTP_Request

=begin
 SELECT title, isbn
postgres-#         FROM books LEFT OUTER JOIN editions
postgres-#         ON (books.id = editions.book_id);


select cgst.id, search_term from  cached_geo_search_terms as cgst  
 left outer join cached_geo_searches as cgs
 on (cgs.cached_geo_search_term_id=cgst.id)
 where address is null
 order by search_term
 ;
=end


##
# Location struct

Location = Struct.new :address, :latitude, :longitude, :country, :admin_area, :subadmin_area, :locality,
                       :dependent_locality, :accuracy, :name, :status_code,
                       :bbox_west, :bbox_east, :bbox_south, :bbox_north

class GoogleGeocodeJsonClient
  
  
  ##
  # Creates a new GoogleGeocode that will use Google Maps API key +key+.  You
  # can sign up for an API key here:
  #
  # http://www.google.com/apis/maps/signup.html

  def initialize(key)
    @key = key
    @url = 'http://maps.google.com/maps/geo?output=json&oe=utf8&sensor=false&key='+@key
    puts @url
  end
  
  #Set the viewport bias
  def set_viewport_bias(westing, southing, easting, northing)
    @viewport_centre = [
            (westing+easting)/2,
            (northing+southing)/2,
    ]
    @viewport_width = (easting-westing)/2;
    @viewport_height = (northing-southing)/2
  end
  
  
  
  #Reset the viewport bias
  def reset_viewpoint_bias
    @viewport_centre = nil
    @viewport_width = nil
    @viewport_height = nil
  end
  
  def set_country_bias(country_code)
    @country_bias = country_code.downcase
  end
  
  def reset_country_bias
    @country_bias = nil
  end
  
  
  def geocode(address, memcache_server=nil)
        geo_url = @url+'&q=' + CGI.escape(address)
        
        geocoder_json = '' #What is returned
        
        bias_key="NONE"
        bias_key = @country_bias if !@country_bias.blank?
        
        digsig = Digest::SHA256.hexdigest(address+':'+bias_key)
        memcache_key = "googlegeocoderjson_#{digsig}"
        
        if !memcache_server.blank?
          geocoder_json = memcache_server[memcache_key]
          puts "GOOGLE: geocoder info cached, cache was #{memcache_server}"
        end
        
        locations = []
        
        if geocoder_json.blank?
            
            
            puts "GOOGLE: geocoder info not cached"
            #Restrict to viewpoint centre if avail
            if !@viewport_centre.blank?
              geo_url << "&ll=#{@viewport_centre[1]},#{@viewport_centre[0]}"
              geo_url << "&spn=#{@viewport_height},#{@viewport_width}"
            end

            #Restrict to country bias
            if !@country_bias.blank?
              geo_url << "&gl="+@country_bias
            end

            puts "GEOCODER URL:#{geo_url}"



            geocoder_json = fetch(geo_url)

            puts "JSON:"
            puts geocoder_json.to_yaml
            if !memcache_server.blank?
                puts "MEMCACHE KEY:#{memcache_server}"
                memcache_server[memcache_key] = geocoder_json
            end
        end
        
        

        res = JSON.parse(geocoder_json.body)
        puts res.to_yaml
        
        search_term=res['name']
        status_code=res['Status']['code']
        
        

        placemarks = res['Placemark']
        if !placemarks.blank?
          puts "CLASS:#{placemarks.class}"
          
          
          for placemark in placemarks
            location = Location::new
            location.name=res['name']
            location.status_code=res['Status']['code']
            location.address = placemark['address']
            

            puts "TRACE (#{location.address}):"+location.status_code.to_s
          
            #puts "ADDRESS FOUND"
            coordinates = placemark['Point']['coordinates']
            location.latitude= coordinates[1]
            location.longitude = coordinates[0]   
            #puts "COORS FOUND"
              
            address_details = placemark['AddressDetails']
          
            #Note that dependent locality sometimes comes on its own, not just inside locality
            #puts"PPPPPP"
          
            country = address_details['Country']
          
            if !country.blank?
              location.country = country['CountryName']
              puts "TRACE 1"
              locality = country['Locality']
              if !locality.blank?
                location.locality = locality['LocalityName']
              end
          
              admin_area = address_details['Country']['AdministrativeArea']
          
              if !admin_area.blank?
                  puts "TRACE 2"
                  
                location.admin_area = admin_area['AdministrativeAreaName']
                subadmin_area = admin_area['SubAdministrativeArea']
                if !subadmin_area.blank?
                  location.subadmin_area = subadmin_area['SubAdministrativeAreaName']
                  puts "TRACE 3"
            
                  #Note that dependent locality sometimes comes on its own, not just inside locality
                  locality = subadmin_area['Locality']
                  if !locality.blank?
                    location.locality = locality['LocalityName']
                    puts "TRACE 4"
                    
                    dependent_locality = subadmin_area['DependentLocality']
                    if !dependent_locality.blank?
                        puts "TRACE 5"
                        
                      location.dependent_locality = ['DependentLocalityName']
                    end
                  end
            
                  dependent_locality = subadmin_area['DependentLocality']
                  if !dependent_locality.blank?
                      puts "TRACE 6"
                      
                    location.dependent_locality = ['DependentLocalityName']
                  end
                end
              end
            end
          
            puts "TRACE 7"
          
            #Now get the lat lon box
            extended_data = placemark['ExtendedData']
            if !extended_data.blank?
              latlonbox = extended_data['LatLonBox']
              if !latlonbox.blank?
                location.bbox_west = latlonbox['west']
                location.bbox_east = latlonbox['east']
                location.bbox_north = latlonbox['north']
                location.bbox_south = latlonbox['south']
              end
            end
            puts "TRACE 8"
            
            puts "TRACE 8a"
            location.accuracy = address_details['Accuracy']
            puts "TRACE 8b"
            locations << location
            
          end
          
          puts "===="
          
          puts "TRACE 9"
          
          puts location.to_yaml
          puts "FOUND LOCATION:#{location.address}"
        end


        puts "FOUND #{locations.size} LOCATIONS"


    
    
        {
          :search_term => search_term,
          :status_code => status_code,
          :locations => locations
        }

  end
  
  
=begin
locations

=end
  
  private

  def fetch(uri_str, limit = 10) 
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end
end