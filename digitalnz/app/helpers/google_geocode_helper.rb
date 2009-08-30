require 'open-uri'
require 'cgi'
require 'hpricot'
require 'iconv'

module GoogleGeocodeHelper
  
  def geocodeFunNOT(address_for_geocoding)
    url = ["http://maps.google.com/maps/geo?q="]
    url <<  URI.encode(address_for_geocoding)
    url << "&output=xml&key="
    url << GOOGLE_MAPS_API_KEY
    
    result = {}
    
      open(url.to_s) do |file|
        @body = file.read
        puts url
        puts "============"
        puts @body
        puts "============"
        doc = Hpricot(@body)

        (doc/:status/:code).each do |code|
          result[:error_code] = code.inner_html
        end

        (doc/:country/:countrynamecode).each do |country_code|
          result[:country] = country_code.inner_html
        end

        (doc/:country/:administrativearea/:administrativeareaname).each do |area|
          result[:state] = Iconv.conv('utf-8', 'ISO-8859-1', area.inner_html)
        end

        (doc/:country/:administrativearea/:subadministrativearea/:subadministrativeareaname).each do |sub_area|
          result[:county] = Iconv.conv('utf-8', 'ISO-8859-1', sub_area.inner_html)
        end

        (doc/:country/:administrativearea/:subadministrativearea/:locality/:dependentlocality/:dependentlocalityname).each do |t_area|
          result[:suburb] = Iconv.conv('utf-8', 'ISO-8859-1', t_area.inner_html)
        end 

        (doc/:point/:coordinates).each do |link|
          longitude, latitude = link.inner_html.split(',')
          result[:longitude] = longitude
          result[:latitude] = latitude
        end    
      end
      
      result
  end
end