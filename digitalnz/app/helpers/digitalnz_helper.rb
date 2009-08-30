require 'open-uri'
require 'cgi'
require 'hpricot'
require 'iconv'
require 'cgi'

module DigitalnzHelper
  
  
  def fix_chars(le_string)
    result = ''
    if !le_string.blank?
      result = CGI.unescapeHTML(le_string)
      result.gsub!('&apos;', "'")
    end
    result
  end
  
  def get_metadata(record_number)
    url = "http://api.digitalnz.org/records/v1/#{record_number}.json?api_key="
    url << DIGITAL_NZ_KEY
    
    result = {}
    
    metadata = {}
    
    puts "FETCHING #{url}"
    
     res = fetch(url)
     res = JSON.parse(res.body)
     mets = res['mets']
     dmdSec = mets['dmdSec']
     for section in dmdSec
      wrap = section['mdWrap']
       for xmldata in wrap['xmlData']
         metakey_split = xmldata[0].split(':')
         namespace = metakey_split[0]
         next if namespace == '@xmlns'
         metakey = metakey_split[1]
         
         metadata[namespace] = {} if metadata[namespace].blank?
           for item in xmldata
             if item.class.to_s == 'Hash'
               metadata[namespace][metakey] = fix_chars(item['$'])
             elsif item.class.to_s == 'Array'
               multi = []
               for multi_item in item
                 multi << fix_chars(multi_item['$'])
               end
               metadata[namespace][metakey] = multi
             end
         end
       end
     end
     
     
     puts metadata.to_yaml

     metadata
  end
  
  

  private

  def fetch(uri_str, limit = 10) 
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    response = Net::HTTP.get_response(URI.parse(uri_str.strip))
    case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      response.error!
    end
  end
  
end