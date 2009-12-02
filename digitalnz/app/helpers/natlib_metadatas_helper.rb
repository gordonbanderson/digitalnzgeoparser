require 'digitalnz'
DigitalNZ.api_key = DIGITAL_NZ_KEY

module NatlibMetadatasHelper
  
 
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
            puts "\nRETRIEVING PAGE #{page}"
            facets = digital_nz_search_result.facets
            facet_fields = query_hash[:facets].split(',')

            #Now create new records if necessary
            #check metadata IDs
            new_metadata_results = []
            metadata_records = {}
            for result in digital_nz_search_result.results
                nl = NatlibMetadata.find_by_natlib_id(result.id)

                if nl.blank?
                   new_metadata_results << result if nl.blank?
                   new_record_ctr = new_record_ctr+1              
                else
                    old_record_ctr = old_record_ctr + 1
                    metadata_records[result.id] = nl
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
