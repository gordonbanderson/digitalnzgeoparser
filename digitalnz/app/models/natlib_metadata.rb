require 'digitalnz'
require 'digitalnz_helper'

include DigitalnzHelper

class NatlibMetadata < ActiveRecord::Base
  
  PARA_BREAK="\n\n"
  
  
  belongs_to :tipe
  has_many :subjects
  has_many :coverages
  has_many :placenames
  has_many :formats
  has_many :relations
  has_many :rights
  has_many :identifiers
  has_many :categories
  has_many :record_dates
  
  has_one :submission
  
  #This is text that will be checked for geo locations
  def geo_text
    result = ""
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
  
  
  
  def self.parse_metadata_api(record_number)
      puts "Getting metadata for record #{record_number}" #eg 68346
      result = get_metadata(record_number)
      metadata = NatlibMetadata::new
      metadata.natlib_id = record_number
      metadata.title = result['dc']['title']
      metadata.creator = result['dc']['creator']
      metadata.contributor = result['dc']['contributor']
      metadata.language = result['dc']['language']
      metadata.description = result['dc']['description']
      metadata.publisher = result['dc']['publisher']
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
