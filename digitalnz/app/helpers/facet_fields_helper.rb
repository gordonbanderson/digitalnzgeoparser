module FacetFieldsHelper
    
    #Work out from the URL params the facet field objects that map
    #FIXME - only works with valid values currently
    def parse_facet_params(facet_params)
        key = false
        last_key = facet_params[0]
        facet_hash = {}
        for i in 1..facet_params.length
            if !key
                facet_hash[last_key] = facet_params[i]
            else
                  last_key = facet_params[i]
           end

           key = !key
           logger.debug "#{key} - #{last_key} - #{facet_params[i]}"
           i = i + 1
        end
        
        
        facets = {}
        for perm in facet_hash.keys
            facet_parent = FacetField.find_by_permalink(perm)
            facet_child = FacetField.find_by_permalink(facet_hash[perm])
            facets[facet_parent] = facet_child
        end
        

        facets
    end
end
