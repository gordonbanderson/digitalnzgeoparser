class NatlibMetadatasController < ApplicationController
  require 'will_paginate'
  
  ZOOM_BOUNDS = [0.00001, 0.00005, 0.0002, 0.002, 0.02, 0.2,0.5,1,2,4,32,64,128,256,512]
  
  #Page size for plain text results, e.g. coverages
  TEXT_LISTPAGE_SIZE=100
  
  #Page size for natlib results
  PAGE_SIZE=20
  
  SHADES='fedcba9876543210'

  #This maps yahoo extent sizes to google map scale
  EXTENT_SIZE = {
    'Timezone' => 4,
    'Town' => 11,
    'Zip' => 14,
    'County' => 8,
    'Suburb' => 13,
    'Colloquial' => 10,
    'Supername' => 1,
    'Island' => 5
  }
  
  def map
    
=begin
    select s.id as submission_id, s.area, n.id as natlib_id, n.natlib_id as natlib_record_id from submissions s
    inner join natlib_metadatas n
    on (s.natlib_metadata_id = n.id  )
    where area is not null
    order by area desc;
    
    
    FOR MEASUREMENT
    select s.id as submission_id, s.area, n.id as natlib_id, n.natlib_id as natlib_record_id from submissions s
    inner join natlib_metadatas n
    on (s.natlib_metadata_id = n.id  )
    where area is not null
    order by area desc;
=end    
    
    id_string = params[:id].split('-')[0]
    @natlib_metadata = NatlibMetadata.find_by_natlib_id(id_string)
    
    @title = 'Digital NZ:'+@natlib_metadata.title
    
    #Filter by accuracy - show all if this is blank
    @filter = params[:filter]
    @filter = 11 if @filter.blank?
    
    #Prepare the amp for the view
=begin
     @map = GMap.new("map_div")
     @map.control_init(:large_map => true,:map_type => true)
     @map.center_zoom_init([@map_latitude,@map_longitude,],1)
=end
     @submission = @natlib_metadata.submission
     if !@submission.blank?
       @centroid = @submission.centroid
       @map = GMap.new("map_div")
       @map.control_init(:large_map => true,:map_type => true)
       
       @size = 7 if @size.blank?

       # If we have coordinates found, take an average for centre and heuristic for size
       # from the google search results
       @n_places_found = @submission.cached_geo_searches.length
       logger.debug "TRACE:#{@n_places_found} found"
       if @n_places_found > 0
         # if the submission area is small, zoom in more
  
            
            @search_terms = {}

            for cached_geo_search in @submission.cached_geo_searches
              search_term = cached_geo_search.cached_geo_search_term.search_term
              if @search_terms[search_term].blank?
                @search_terms[search_term] = 1
              else
                @search_terms[search_term] = @search_terms[search_term]+1
              end
            end
            
            
            @stopped_words = @submission.filtered_by('stopped')
            @removed_by_calais = @submission.filtered_by('filtered_by_calais')
            @stopped = @submission.filtered_by('stopped')
            @no_matches = @submission.filtered_by('no_geocoder_matches')
            @too_short = @submission.filtered_by('too_short')
            @geoparser_failed = @submission.filtered_by('geoparser_failed')

            @phrases = Phrase.find(:all, :conditions => ["words in (?)", @search_terms.keys])
            pfs = @submission.phrase_frequencies
            @phrases = pfs.map{|pf| pf.phrase.words}

            @phrase_frequencies = {}
            for pf in pfs
            @phrase_frequencies[pf.phrase.words] = pf.frequency
            end
            
            
            
              @accuracies = {}
              minx=+180
              maxx=-180
              miny=+90
              maxy=-90

              for cached_search in @submission.cached_geo_searches
                if cached_search.accuracy.google_id < @filter.to_i
                  info_text = cached_search.address
                  info_text << '<br/>'
                  info_text << cached_search.accuracy.name
                  info_text << '<br/>'
                  info_text << '"'+cached_search.cached_geo_search_term.search_term+'"'
                  @accuracies[cached_search.cached_geo_search_term.search_term] = cached_search.accuracy.name
                  @map.overlay_init(GMarker.new([cached_search.latitude, cached_search.longitude],
                   :title => cached_search.cached_geo_search_term.search_term,
                   :options => {:draggable => true},
                   :info_window =>info_text
                   ))

                   w = cached_search.bbox_west
                   e = cached_search.bbox_east
                   s = cached_search.bbox_south
                   n = cached_search.bbox_north

                   minx = [minx,w].min
                   maxx = [maxx,e].max
                   miny = [miny,s].min
                   maxy = [maxy,n].max

                   fill_shade = SHADES[cached_search.accuracy.google_id].chr
                   fill_color  = "#000"
                   fill_alpha = cached_search.accuracy.google_id * 0.04
                   polygon = GPolygon.new([[n,w],[n,e],[s,e],[s,w], [n,w]],"#ff0000",1,1,fill_color, fill_alpha)
                   @map.overlay_init(polygon)
                end
              end
            end

          
            #Deal with centre of points
            le_sum = 0
            cen_lat_array = @submission.cached_geo_searches.map{|l| l.latitude}
            cen_lon_array = @submission.cached_geo_searches.map{|l| l.longitude}
            cen_lat = cen_lat_array.sum.to_f / cen_lat_array.size
            cen_lon = cen_lon_array.sum.to_f / cen_lon_array.size
            logger.debug "TRACE: Average centre is #{cen_lat}, #{cen_lon}"
            
            @info = "BOUNDED BY #{minx} => #{maxx}, #{miny} => #{maxy}"
            @bounds = GLatLngBounds.new([miny, minx], [maxy,maxx])
            @area_lat_lon = (maxx-minx)*(maxy-miny)
            @size = get_size_from_km_area miny, minx, maxy, maxx
            @center = [(miny+maxy)*0.5, (minx+maxx)*0.5 ]
            @map.center_zoom_init(@center, @size)

       else
        logger.debug "TRACE:no places found, using yahoo"
         #Google has provided no answers, so use the yahoo extents instead
         #If Yahoo has also failed, show the entire world
         if !@centroid.blank?
          logger.debug "TRACE: Using yahoo centroid as it is not blank (#{@centroid.latitude}, "+
                      "#{@centroid.longitude}) of extent type #{@centroid.extent_type}"
           @size = EXTENT_SIZE[@centroid.extent_type]
           logger.debug(@centroid.extent_type)
           @map.center_zoom_init([@centroid.latitude,@centroid.longitude], @size)
         else
           logger.debug "TRACE: Defaulting to the whole world as both yahoo and google cannot provide info"
           @size = 4
           @map.center_zoom_init([0,0], @size)
         
         end
      end
       


       
       
       





     
     


     
    
    @all_accuracies = Accuracy.find(:all, :order => :id)
    @inverted_accuracies = @accuracies.invert #Accuracy name => [geonames]
    @archive_search = ArchiveSearch::new
    render :layout => 'metadata_record'
  end
  
  
  
=begin
<a href="/geoparsed/provider-and-title">Content Provider, Title</a> | 
<a href="/geoparsed/lowest-area">Lowest Area</a> | 
<a href="/geoparsed/highest-area">Highest Area</a> | 
<a href="/geoparsed/no-places-found">No Area Defined</a>
=end

    #Display a list of addresses
    def addresses
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        @addresses = GeoparsedLocation.paginate :select => 'distinct address', :page => @page,
        :per_page => PAGE_SIZE
        render :layout => 'archive_search_results'
    end
    
    
    #Display a list of natlib results for said address
    def address
       @page = 1
       @page = params[:page] if !params[:page].blank?
       @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
       address_name = params[:name]
       @results = GeoparsedLocation.paginate :conditions => ["address = ?", address_name],
        :page => @page, :per_page => PAGE_SIZE
       render :layout => 'archive_search_results'
    end

    #Display a list of all coverages
    def coverages
       natlib_properties 'coverage'
    end
    
    #Display a paged set of natlib records for a given coverage
    def coverage
        natlib_property 'coverage'
    end

  #Render those records already geoparsed
  def geoparsed
    #Check the page
    @page=1
    @page = params[:page] if !params[:page].blank?
    @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page

    #Default ordering if none provied
    @order = 'title'
    
    #Alter order above depending on parameters
    @order_requested = params[:order]
    conditions = []
    
    if @order_requested == 'lowest-area'
        @order = 'area,title'
        conditions = ["area is not ?", nil]
        
    elsif @order_requested == 'highest-area'
        @order = 'area desc, title'
        conditions = ["area is not ?", nil]
        
    elsif @order_requested == 'no-places-found'
        conditions = ["area is ?", nil]
        
    end

    
    
    @natlib_records = GeoparsedRecord.paginate :page => @page, :order => @order, :conditions => conditions, :per_page => PAGE_SIZE
     
    #Work out page metainfo
	@start_count = 1+(@natlib_records.current_page-1) * PAGE_SIZE
	@finish_count = PAGE_SIZE * @natlib_records.current_page
	@finish_count = @natlib_records.total_entries if @natlib_records.total_entries < @finish_count
	@total_count = @natlib_records.total_entries
	
	render :layout => 'archive_search_results'
    
  end
  
  
  
  
  #Convert area to a size
  def get_size_from_km_area miny, minx, maxy, maxx
      area_lat_lon = (maxx-minx)*(maxy-miny)
      pos = 0
      for bound in ZOOM_BOUNDS
         if area_lat_lon < bound
             break
        end 
        pos = pos + 1
      end
      
      zoom_level = 16 - pos
      zoom_level
  end
  
  
  
  #Helper methods for the controller, made private so they cannot be called directly
  #Display a list of all coverages
  #@param propertyname - name of a property, e.g. coverage
  def natlib_properties(property_name)
        @clazz = property_name.titleize.constantize
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        @properties = @clazz.paginate :select => 'name,permalink', :page => @page, :order => 'name', :per_page => TEXT_LISTPAGE_SIZE
        @n_pages = 1+@properties.total_entries/TEXT_LISTPAGE_SIZE
      render :template => 'shared/properties', :layout => 'archive_search_results'
  end
  
  #Render a single property, e.g. a coverage of 'Wellington' or a subject of 'Trains'
  def natlib_property(property_name)
        @clazz = property_name.titleize.constantize
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        permalink = params[:name]
        @property = @clazz.find_by_permalink(permalink)
        @natlib_metadatas = @property.natlib_metadatas.paginate :page => @page, :order => 'title', :per_page => PAGE_SIZE
        @n_pages = 1+@natlib_metadatas.total_entries/TEXT_LISTPAGE_SIZE

        render :template => 'shared/property', :layout => 'archive_search_results' 
  end
end
