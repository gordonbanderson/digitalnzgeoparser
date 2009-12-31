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
    
    
    #Convert a list of facet ids to the nice url format, e.g. /category/images/collection/flickr
    #@param facets mapping of filtername -> facet object
    #@param new_filter_facet the extra filter being applied
    def self.facets_to_seo_url(facets, new_filter_facet)
        result = ''
        
        keys = facets.keys
        keys << new_filter_facet.permalink
        
        for key in keys.sort
            facet = facets[key]
            if facet.blank?
               facet = new_filter_facet 
            end
            if !facet.parent.blank?
                result << "/#{facet.parent.permalink}/#{facet.permalink}"  
            end
        end
        result
    end
    
    
    #Convert the facet name into singular or plural
    def self.parent_facet_name(lower_case, pluralize=false)
       result = lower_case.camelize
       result.gsub!('ContentPartner', 'Content Partner')
       result 
    end
end
