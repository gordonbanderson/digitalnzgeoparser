#!/usr/bin/env ./maps/script/runner

require 'simple_http'
require "rexml/document"
require 'pp'
include REXML
require 'calais'

raise(StandardError,"Set Open Calais login key in ENV: 'OPEN_CALAIS_KEY'") if !CALAIS_KEY

PARAMS = "&paramsXML=" + CGI.escape('<c:params xmlns:c="http://s.opencalais.com/1/pred/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"><c:processingDirectives c:contentType="text/html" c:outputFormat="xml/rdf"></c:processingDirectives><c:userDirectives c:allowDistribution="true" c:allowSearch="true" c:externalID="17cabs901" c:submitter="ABC"></c:userDirectives><c:externalMetadata></c:externalMetadata></c:params>')
require 'digest/sha2'


class ParsingException < Exception
    
end

=begin
coordinates = CACHE["mb_#{code}"]

#Save in memcache
if coordinates.blank? #Create them and save in memcache
  coordinates = ""
  mbg = MeshblockGeometry.find(:first, :conditions => ["mb06=?",code.to_s])
  the_geom = mbg.the_geom
  #puts the_geom.methods.sort.join(", ")
  #puts the_geom.to_yaml
  for polygon in the_geom
    for linear_ring in polygon
      for point in linear_ring
        coordinates << "#{point.x} #{point.y}"
        coordinates << "\n"
      end
    end
  end

  CACHE["mb_#{code}"] = coordinates
=end

module CalaisHelper

  def get_cached_tags(text)
    puts "==== GET CACHED TAGS ===="
    digsig = Digest::SHA256.hexdigest(text)
    calais_cache_key = "calais31_#{digsig}"
    puts digsig
    result = CalaisSubmission.find_by_signature(digsig)
    
    tags = get_tags(text, calais_cache_key)
puts "TAGS1:"
puts tags.to_yaml

    if !result.blank?
        Statistic.increment('calaismemcache')
        
    else
        
      cs = CalaisSubmission::new
      cs.signature = digsig
      cs.save!
      for tag_key in tags.keys
        puts '--'
        puts tag_key
        tk = CalaisWord.find_by_word(tag_key)
        if tk.blank?
          tk = CalaisWord::new
          tk.word = tag_key
          tk.save!
        end

=begin        
        for tagged_result in tags[tag_key]
          puts "\t#{tagged_result}"
          cw = CalaisWord.find_by_word(tagged_result)
          if cw.blank?
            cw = CalaisWord::new
            cw.word = tagged_result
            cw.save!
          end
          
          #Now create calais entries
          ce = CalaisEntry::new
          ce.calais_child_word = cw
          ce.calais_parent-word = tk
          ce.save
        end
=end

      end
    end
    
    tags
  end
  
  
  
  def get_tags(text, memcache_key)
      
      response = CACHE[memcache_key]
      if response.blank?
          Statistic.increment('calaislive')
          
          client = Calais::Client.new(:content => text, :license_id => 'cw7evzbgkhnhwj9d5msm7ree')

          client.use_beta = false
          client.output_format = :json
          client.reltag_base_url = 'http://opencalais.com'
          client.calculate_relevance = true
          client.metadata_enables = Calais::KNOWN_ENABLES
          client.metadata_discards = Calais::KNOWN_DISCARDS
          client.allow_distribution = true
          client.allow_search = true
          client.external_id = Digest::SHA1.hexdigest(client.content)
          client.submitter = 'calais.rb'

          tags = {}
          x = client.enlighten()
          response = JSON.parse(x)
          CACHE[memcache_key] = response 
      else
          Statistic.increment('calaismemcache')
          
      end
      
      tags = {}

      puts response.to_yaml
      puts "++++++++++++++++++++++++++\n\n\n\n\n\n\n\n\n"
      for key in response.keys
          next if key=='doc'
          entry = response[key]
          puts "\n\nKEY:#{key}"
          puts "\t#{entry['name']}"
          puts "\tRelevance=#{entry['relevance']}"
          puts "\tType=#{entry['_type']}"
          puts "\tOrgType=#{entry['organizationtype']}"
          puts "\tTypeRef=#{entry['_typeReference']}"
          puts "\t_typeGroup=#{entry['_typeGroup']}"
          puts "\tnationality=#{entry['nationality']}"

          tipe = entry['_type']

          name = entry['categoryName']
          typegroup = entry['_typeGroup']
          puts "TG:#{typegroup}"
          if typegroup != nil
              puts "FOUND TYPEGROUP:#{typegroup}"
              if ['relations', 'topics'].include? typegroup
                  tags[typegroup] = [] if tags[typegroup] == nil
                  tags[typegroup] << tipe
              end

          end

          skip = false

          if typegroup == 'topics'
              name = entry['categoryName']
              puts "Topic:#{name}"
              tipe = typegroup
              skip = true
          elsif tipe == 'GenericRelations'
              name = entry['verb']
          elsif tipe == 'Quotation'
              name = entry['quote']
          elsif tipe == 'PersonCareer'
              name = entry['careertype']
          elsif tipe == 'PersonCommunication'
              name = entry['persondescription']
          elsif tipe == 'PersonTravel'
              name = entry['locationdestination']
          elsif tipe == 'FamilyRelation'
              name = entry['familyrelationtype']
          elsif tipe == 'NaturalDisaster'
              name = entry['naturaldisaster']
          else
              name = entry['name']
          end

          puts "TIPE:#{tipe} of len #{tipe.length}"
          tags[tipe] = [] if tags[tipe] == nil
          tags[tipe] << name        

          topics = tags['topics']
          if topics != nil
              new_topics = []
              for topic in topics
                 if topic != nil
                     new_topics << topic
                 end 
              end

              tags['topics'] = new_topics

          end

      end

      for key in response.keys
         puts "KEY:#{key}" if key[0,4] != 'http'
      end

      puts "TAGS:::::::"
      puts tags.to_yaml
      
      tags
      
  end

  def get_tags_old(text, memcache_key)
    data = "licenseID=#{CALAIS_KEY}&content=" + CGI.escape(text)
    puts "DATA:#{data.to_yaml}"
    
    response = CACHE[memcache_key]
    if response.blank?
      puts "UNCACHED"
      http = SimpleHttp.new "http://api.opencalais.com/enlighten/calais.asmx/Enlighten"
      response = CGI.unescapeHTML(http.post(data+PARAMS))
    else
      puts "CACHED"
    end
    
    h = {}
    
    if response.include?('<Error Method="ProcessText"')
      puts "Error parsing at Calais end"
      puts "======="
      puts response
      puts "/======"
      puts 
      raise ParsingException::create (:message => "An error occurred with Calais - #{response}")
        
      
    else
        #Do not cache if broken response, only save valid
        CACHE[memcache_key] = response
        
      index1 = response.index('terms of service.-->')
      index1 = response.index('<!--', index1)
      index2 = response.index('-->', index1)
      txt = response[index1+4..index2-1]
      lines = txt.split("\n")
      lines.each {|line|
        index = line.index(":")
        h[line[0...index]] = line[index+1..-1].split(',').collect {|x| x.strip} if index
      }
    end
    h
  end 

end

