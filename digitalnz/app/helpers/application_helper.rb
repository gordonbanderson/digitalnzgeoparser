# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    
    #Make a friendly SEO URL
    def seo_id(id,phrase)
        result = id.to_s
        result << '-'
        for part in phrase.parameterize.split('-')
            result << part
            result << '-'
            break if result.length > 50
        end
        result[-1]='' if result[-1]='-'
        result
    end
    
    #Set the title from a view
    def set_title(new_title)
       @title = "DigitalNZ Geoparser:#{new_title}" 
    end
end
