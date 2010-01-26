require 'digitalnz'
DigitalNZ.api_key = DIGITAL_NZ_KEY

module NatlibMetadatasHelper
  
  
  #Search for a placename in SOLR land by converting the likes of Willis St, Wellington into a
  #title search, an exact search, and a free search with weighting towards the former
  def self.solr_query(address)
    parts = address.split(',')
    
    if parts[-1] =~ /\d{4}/
      address.gsub!(parts[-1], '')
      RAILS_DEFAULT_LOGGER.debug address[-1]
      address[-1] = '' if address[-1] == 44
        
      address.strip!
      parts = address.split(',')
      
    end

    result = ""
    
    result << '(title:"'+address+'")^4 OR '
    result << '("'+address+'")^3 '
    result << 'OR ('
    part_string = ''
    for part in parts
      part_string << "+#{part} "
    end
    part_string.strip!
    result << part_string
    result << ")^2 OR (#{address})"
    
    result
  end
  
  #Convert a distance in metres to the likes of 240m or 12.3km
  def self.pretty_distance(area)
    result = 'No area defined'
    
    
    if !area.blank?
        rounded_area = area.round.to_s
          if area < 10
              rounded_area = number_to_n_significant_digits(area,2)
          elsif area < 100
              rounded_area = number_to_n_significant_digits(area,2)

          end
      result = "#{rounded_area} m"
    end
    result
  end
  
  
  def self.number_to_n_significant_digits(number, n = 3)
    ("%f"%[("%.#{n}g"%number).to_f]).sub(/\.?0*\z/,'')
  end
  
 
#  Populate the natlib_metadatas table with shells of metadata records discovered from searches
#  against the desired facets
#  @param query the search term used
#  @param facet_filters name value pairs of facets to filter by
#  @param max_num_records stop iterating when finished or after this number
  
  def populate_from_search(query, facet_filters,page_size = 100, max_num_records=1000, verbose=false)

      #Initialise counters
      old_record_ctr = 0
      new_record_ctr = 0
      
      query_hash = {}
      facetted_query = ""
      facetted_query << query
      facetted_query << ' '
      for ff in facet_filters.keys
          puts "FACET FILTER:#{ff}"
          facetted_query << "#{ff}:#{facet_filters[ff]} "
      end
      query_hash[:search_text] = facetted_query
      query_hash[:num_results] = page_size.to_s
      query_hash[:start] = '0'
      query_hash[:facet_num_results]='200' #Have emailed list suggesting further facets in content creator / provider categories
      query_hash[:facets] = 'category,content_partner,creator,language,rights,century,decade,year'
      digital_nz_search_result = DigitalNZ.search(query_hash)
      puts "FOUND:#{digital_nz_search_result.count} records" if verbose
      
      n_pages = ([max_num_records,digital_nz_search_result.count].min)/page_size
      puts "N PAGES TO RETRIEVE:#{n_pages}"
      
      for page in 0..n_pages
            puts "\nRETRIEVING PAGE #{page} of #{n_pages} for '#{query}'"
            facets = digital_nz_search_result.facets
            facet_fields = query_hash[:facets].split(',')

            #Now create new records if necessary
            #check metadata IDs
            new_metadata_results = []
            metadata_records = {}
            
            natlib_ids = digital_nz_search_result.results.map{|r| r.id}
            natlib_records_existing = NatlibMetadata.find(:all, :conditions => [
                "natlib_id in (?)",
                natlib_ids
            ]
            )
            
            already_existing_ids = natlib_records_existing.map{|r|r.natlib_id.to_i}

            for result in digital_nz_search_result.results
                if already_existing_ids.include? result.id.to_i
                    old_record_ctr = old_record_ctr + 1
                else    
                    new_metadata_results << result
                    new_record_ctr = new_record_ctr+1
                end
            end


            for result in new_metadata_results
                nl = NatlibMetadata.new_from_search_result(result)
                metadata_records[nl.natlib_id.to_s] = nl
            end

            puts "CREATED:#{new_record_ctr}" if verbose
            puts "ALREADY EXISTED:#{old_record_ctr}" if verbose
            
            query_hash[:start] = (page_size*page).to_s
            digital_nz_search_result = DigitalNZ.search(query_hash)
            
      
    end  
       
  end
  
end
