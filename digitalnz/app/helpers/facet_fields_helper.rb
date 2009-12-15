module FacetFieldsHelper
    
    #Work out from the URL params the facet field objects that map
    #FIXME - only works with valid values currently
    def parse_facet_params_array(facet_params_array)
        key = false
        last_key = facet_params_array[0]
        facet_hash = {}
        for i in 1..facet_params_array.length
            if !key
                facet_hash[last_key] = facet_params_array[i]
            else
                  last_key = facet_params_array[i]
           end

           key = !key
           logger.debug "#{key} - #{last_key} - #{facet_params_array[i]}"
           i = i + 1
        end
        
        
        facets = {}
        for perm in facet_hash.keys
            facet_parent = FacetField.find(:first, :conditions => ["parent_id is null and permalink=?", perm])
            facet_child = FacetField.find(:first, 
                :conditions => ["parent_id = ? and permalink = ?", facet_parent.id, facet_hash[perm] ])
            facets[facet_parent] = facet_child
        end
        

        facets
    end
end
