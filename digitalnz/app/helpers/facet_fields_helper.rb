module FacetFieldsHelper
    
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

        facet_hash
    end
end
