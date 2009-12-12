require 'digitalnz'
require 'digitalnz_helper'

include DigitalnzHelper

class NatlibMetadata < ActiveRecord::Base
  
  PARA_BREAK="\n\n"
  
  

  
  has_one :submission
  
  has_and_belongs_to_many :content_partners #Duplicate tested
  has_and_belongs_to_many :creators #Duplicate tested
  has_and_belongs_to_many :contributors #Duplicate tested
  has_and_belongs_to_many :publishers #NO SAMPLES IN DEV DB (has singularity check though)
  has_and_belongs_to_many :collections #Duplicate tested
  has_and_belongs_to_many :languages #Duplicate tested
  has_and_belongs_to_many :placenames #Duplicate tested
  
  has_and_belongs_to_many :tipes #Duplicate tested
  has_and_belongs_to_many :subjects #Duplicate Tested
  has_and_belongs_to_many :coverages #Duplicate Tested
  has_and_belongs_to_many :categories #NO SAMPLES IN DEV DB - FIXME CHECK PASTIE, should be likes of Images etc
  has_and_belongs_to_many :identifiers #All unique?
  has_and_belongs_to_many :formats #Duplication tested
  has_and_belongs_to_many :rights #Duplication tested
  has_and_belongs_to_many :relations #Duplication tested
 
  has_many :record_dates
  
  
  
  
  #This is text that will be checked for geo locations
  def geo_text(return_array=false)
    if return_array
       result = [] 
    else
        result = ""
    end
    result << title
    result << PARA_BREAK
    result << description if !description.blank?
    result << PARA_BREAK
    for p in placenames
      result << p.name
      result << PARA_BREAK
    end
    
    for c in coverages
      result << c.name
      result << PARA_BREAK
    end
    
    for s in subjects
      result << s.name
      result << PARA_BREAK
    end
    
    result
    
  end
  
  
  #Create a new natlib metadata record from a search result
  #Note that rendering of the search result uses in main the search result info so no need to populate
  #or attempt to populate natlib record here
  def self.new_from_search_result(searchresult)
    metadata = NatlibMetadata::new
    metadata.natlib_id = searchresult.id
    metadata.title = searchresult.title
    metadata.description = searchresult.description
    metadata.pending = true
    metadata.save!
    return metadata
  end
  
=begin

id              | integer                     | not null default nextval('natlib_metadatas_id_seq1'::regclass)
creator         | text                        | 
contributor     | text                        | 
description     | text                        | 
language        | text                        | 
publisher       | text                        | 
title           | text                        | 
collection      | text                        | 
landing_url     | text                        | 
thumbnail_url   | text                        | 
tipe_id         | integer                     | 
content_partner | text                        | 
circa_date      | boolean                     | 
natlib_id       | integer                     | 
created_at      | timestamp without time zone | 
updated_at      | timestamp without time zone | 
pending         | boolean                     | default true


metadata_url: http://api.digitalnz.org/records/v1/959171
category: Images
title: Me and my whanau
content_provider: Kete Horowhenua
source_url: http://api.digitalnz.org/records/v1/959171/source
syndication_date: "2009-11-05T20:50:43.390Z"
id: "959171"
date: "2009-05-19T00:00:00.000Z"
thumbnail_url: http://horowhenua.kete.net.nz/image_files/0000/0008/2572/bio_photo_medium.jpg
description: ""
display_url: http://horowhenua.kete.net.nz/site/images/show/15801-me-and-my-whanau


http://api.digitalnz.org/records/v1/273830.xml?api_key=7dffce0c64ee6a5e2df936a1161979b7


=end
  
  
  #Parse the metadata returned for a single record form the Digital NZ API
  def self.update_or_create_metadata_from_api(record_number)
      puts "Getting metadata for record #{record_number}" #eg 68346
      result = get_metadata(record_number)
      metadata = NatlibMetadata.find_by_natlib_id(record_number)
      metadata = NatlibMetadata::new if metadata.blank?
      metadata.natlib_id = record_number
      metadata.title = result['dc']['title']
      
      #Deal with potentially habtm creators
      creators = []
      dnz_creators = result['dc']['creator']
      if !dnz_creators.blank?
          for creator_string in dnz_creators
              creator = Creator.find_or_create(creator_string)
              creators << creator
          end
      end
      metadata.creators = creators
      
      #Deal with rights
      rights = []
      dc_rights = result['dc']['rights']
      if !dc_rights.blank?
          for right in dc_rights
              r = Right.find_or_create(right)
              rights << r
          end
      end
      metadata.rights = rights
      
      
      
      
      #Deal with potentially habtm contributors
      contributors = []
      dnz_contributors = result['dc']['contributor']
      if !dnz_contributors.blank?
          for contributor_string in dnz_contributors
              contributor = Contributor.find_or_create(contributor_string)
              contributors << contributor
          end
      end
      metadata.contributors = contributors
      
      
      
      #Deal with potentially habtm languages
      languages = []
      dc_languages = result['dc']['language']
      if !dc_languages.blank?
          for language_string in dc_languages
              language = Language.find_or_create(language_string)
              languages << language
          end
      end
      metadata.languages = languages
      
      
      metadata.description = result['dc']['description']

      #Deal with potentially habtm publishers
      publishers = []
      dnz_publishers = result['dc']['publisher']
      if !dnz_publishers.blank?
          for publisher_string in dnz_publishers
              publisher = Publisher.find_or_create(publisher_string)
              publishers << publisher
          end
      end
      metadata.publishers = publishers
      
      metadata.pending = false
      record_dates = result['dc']['date']

      #Appears date can be an array...
      puts "*** DATE CLASS IS #{record_dates.class}"
      if record_dates.class == String
        record_dates = [record_dates]
      end
      
      if !record_dates.blank?
        for the_date in record_dates
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
            
              rd = RecordDate::new
              rd.start_date = start_date
              rd.end_date = end_date
              rd.natlib_metadata = metadata
              rd.save!


            rescue Exception => e
              logger.debug "FAILED TO PARSE DATE:#{the_date}"
              logger.debug e.to_yaml
            end
          end
        end
      end
      
      dc_types = result['dc']['type']
      tipes = []
      if !dc_types.blank?
          for dc_type in dc_types
              tipe = Tipe.find_by_name(dc_type)
              if tipe.blank?
                tipe = Tipe::new
                tipe.name = dc_type
                tipe.save!
              end
              tipes << tipe
          end
        
      end
      metadata.tipes = tipes
      
      
      #Categories
      dnz_cats = result['dnz']['category']
      categories = []
      if !dnz_cats.blank?
          for dnz_cat in dnz_cats
              category = Category.find_or_create(dnz_cat)
              
              categories << category
          end
        
      end
      metadata.categories = categories
      
      #Thumbnails

      metadata.thumbnail_url = result['dnz']['thumbnail_url']
      metadata.landing_url = result['dnz']['landing_url']
      
      collections = []
      for collection_string in result['dnz']['collection']
          collection = Collection.find_or_create(collection_string)
          collections << collection
      end
      metadata.collections = collections
      
      content_partners = []
      for content_partner_string in result['dnz']['content_partner']
          content_partner = ContentPartner.find_or_create(content_partner_string)
          content_partners << content_partner
      end
      metadata.content_partners = content_partners

      #Subjects
      subjects_dc = result['dc']['subject']
      subjects = []
      if !subjects_dc.blank?
        for subject in subjects_dc
          s = Subject.find_or_create subject
          s.save!
          subjects << s
        end
      end
      
      metadata.subjects = subjects

      #Coverages
      coverages_dc = result['dc']['coverage']
      coverages = []
      if !coverages_dc.blank?
        for coverage in coverages_dc
          c = Coverage.find_or_create coverage
          coverages << c
          c.save!
        end
      end
      metadata.coverages = coverages

      #Placenames
      placenames = []
      placenames_dnz = result['dnz']['placename']
      if !placenames_dnz.blank?
        for placename in placenames_dnz
          o = Placename.find_or_create placename
          placenames << o
          o.save!
        end
      end
      
      metadata.placenames = placenames


      #Rights
      formats_dc = result['dc']['format']
      puts formats_dc.to_yaml
      
      
      formats = []
      if !formats_dc.blank?
        for format in formats_dc
          o = Format.find_or_create format
          formats << o
          o.save!
        end
      end
      
      metadata.formats = formats

      #Relations
      relations = []
      things = result['dc']['relation']
      if !things.blank?
        for name in things
          o = Relation.find_or_create name
          relations << o
          o.save!
        end
      end
      
      metadata.relations = relations

      #Identifiers
      things = result['dc']['identifier']
      identifiers = []
      if !things.blank?
        for name in things
          o = Identifier.find_or_create name
          o.name = name
          identifiers << o
          o.save!
        end
      end
      
      metadata.identifiers = identifiers

      metadata.save!
      metadata
    end
    
    
    def dateinfo
      result = ""
      for record_date in record_dates
        result << record_date.pretty_date
      end
      result
    end
  
end
