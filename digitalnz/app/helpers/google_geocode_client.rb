require 'rubygems'
require 'rc_rest'

include REXML

##
# Library for looking up coordinates with Google's Geocoding API.
#
# http://www.google.com/apis/maps/documentation/#Geocoding_HTTP_Request

class GoogleGeocodeClient < RCRest

  ##
  # This is the version you are running.

  VERSION = '1.2.1'

  ##
  # Base error class

  class Error < RCRest::Error; end

  ##
  # Raised when you try to locate an invalid address.

  class AddressError < Error; end

  ##
  # Raised when you use an invalid key.

  class KeyError < Error; end

  ##
  # Location struct

  Location = Struct.new :address, :latitude, :longitude, :country, :admin_area, :subadmin_area, :locality,
                         :dependent_locality, :accuracy

  ##
  # Creates a new GoogleGeocode that will use Google Maps API key +key+.  You
  # can sign up for an API key here:
  #
  # http://www.google.com/apis/maps/signup.html

  def initialize(key)
    @key = key
    @url = URI.parse 'http://maps.google.com/maps/'
  end

  ##
  # Locates +address+ returning a Location struct.

  def locateNOT(address)
    RAILS_DEFAULT_LOGGER.debug "Searching for #{address}"
    begin
      get :geo, :q => address
    rescue Exception => e
      puts "Exception: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      RAILS_DEFAULT_LOGGER.error "Failed to parse google xml,: #{e.class}: #{e.message}\n\t#{e.backtrace.join("\n\t")}"
      raise Error, "Failure to parse xml"
    end
  end

  ##
  # Extracts a Location from +xml+.

  def parse_response(xml)
    result = [] #empty Location array currently
    
    places = XPath.match(xml, "//Placemark")
    for place_element in places
     # puts place_element.to_xml
     
      address = place_element.elements['address'].text
      country = place_element.elements['AddressDetails/Country/CountryNameCode'].text
      admin_element = place_element.elements['AddressDetails/Country/AdministrativeArea']
      admin_area_name_element = admin_element.elements['AdministrativeAreaName'] if !admin_element.blank?
      admin_area = admin_area_name_element.text if !admin_area_name_element.blank?
    
      
      subadmin_area_element = place_element.elements['AddressDetails/Country/AdministrativeArea/SubAdministrativeArea']
      
      if !subadmin_area_element.blank?
        subadmin_area = subadmin_area_element.elements['SubAdministrativeAreaName'].text 
        locality_element = subadmin_area_element.elements['Locality']
        if !locality_element.blank?
          
          locality_name_element = locality_element.elements['LocalityName']
          locality = locality_name_element.text if !locality_name_element.blank?
          dependent_locality_element = locality_element.elements['DependentLocality']
          dependent_locality = dependent_locality_element.elements['DependentLocalityName'].text if ! dependent_locality_element.blank?
        end
        
      end
      
      #Now get the coordinates
      coordinates = place_element.elements['Point/coordinates'].text.split(',')
      longitude = coordinates[0]
      latitude = coordinates[1]
      accuracy_number = place_element.elements['AddressDetails'].attributes['Accuracy']
      accuracy = GoogleGeocodeClient::Accuracy::VALUES[accuracy_number.to_i]
      puts "GGC: ADDRESS:#{address}"
      puts "GGC: COUNTRY:#{country}"
      puts "GGC: ADMIN AREA:#{admin_area}"
      puts "GGC: SUBADMIN AREA:#{subadmin_area}"
      puts "GGC: LOCALITY:#{locality}"
      puts "GGC: DEP LOCALITY:#{dependent_locality}"
      puts "GGC: LAT:#{latitude}"
      puts "GGC: LON:#{longitude}"
      puts "GGC: ACCURACY:#{accuracy_number}"
   
      puts '===='

      
      l = Location::new
      l.latitude = latitude
      l.longitude = longitude
      l.admin_area = admin_area
      l.subadmin_area = subadmin_area
      l.dependent_locality = dependent_locality
      l.locality = locality
      l.accuracy = accuracy_number
      l.country = country
      l.address = address
      result << l
      
   
    end
    
    result
  end

  ##
  # Extracts and raises an error from +xml+, if any.

  def check_error(xml)
    status = xml.elements['/kml/Response/Status/code'].text.to_i
    case status
    when 200 then # ignore, ok
    when 500 then
      raise Error, 'server error'
    when 601 then
      raise AddressError, 'missing address'
    when 602 then
      raise AddressError, 'unknown address'
    when 603 then
      raise AddressError, 'unavailable address'
    when 610 then
      raise KeyError, 'invalid key'
    when 620 then
      raise KeyError, 'too many queries'
    else
      raise Error, "unknown error #{status}"
    end
  end

  ##
  # Creates a URL from the Hash +params+.  Automatically adds the key and
  # sets the output type to 'xml'.

  def make_url(method, params)
    params[:key] = @key
    #FIXME - http://railsforum.com/viewtopic.php?id=529 says change this to KML
    params[:output] = 'kml'

    super method, params
  end

end

##
# A Location contains the following fields:
#
# +latitude+:: Latitude of the location
# +longitude+:: Longitude of the location
# +address+:: Street address of the result.

class GoogleGeocodeClient::Location

  ##
  # The coordinates for this location.

  def coordinates
    [latitude, longitude]
  end

end


#Accuracy constants
class GoogleGeocodeClient::Accuracy
  UNKNOWN='Unknown'
  COUNTRY_LEVEL='Country'
  REGION_LEVEL='Region'
  SUBREGION_LEVEL = 'Subregion'
  TOWN_LEVEL = 'Town'
  POST_CODE_LEVEL = 'Post code'
  STREET_LEVEL = 'Street'
  INTERSECTION_LEVEL='Intersection'
  ADDRESS_LEVEL = 'Address'
  PREMISES_LEVEL = 'Address'
  
  VALUES={
    0 => UNKNOWN,
    1 => COUNTRY_LEVEL,
    2 => REGION_LEVEL,
    3 => SUBREGION_LEVEL,
    4 => TOWN_LEVEL,
    5 => POST_CODE_LEVEL,
    6 => STREET_LEVEL,
    7 => INTERSECTION_LEVEL,
    8 => ADDRESS_LEVEL,
    9 => PREMISES_LEVEL
  }
end

