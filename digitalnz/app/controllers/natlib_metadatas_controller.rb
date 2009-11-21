class NatlibMetadatasController < ApplicationController
  require 'will_paginate'
  
  PAGE_SIZE=20
  
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
    
    @natlib_metadata = NatlibMetadata.find_by_natlib_id(params[:id])
    
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
            if !@submission.area.blank?
              @size = get_size_from_km_area(@submission.area)
            end
          
            #Deal with centre of points
            le_sum = 0
            cen_lat_array = @submission.cached_geo_searches.map{|l| l.latitude}
            cen_lon_array = @submission.cached_geo_searches.map{|l| l.longitude}
            cen_lat = cen_lat_array.sum.to_f / cen_lat_array.size
            cen_lon = cen_lon_array.sum.to_f / cen_lon_array.size
            @map.center_zoom_init([cen_lat,cen_lon], @size)
            logger.debug "TRACE: Average centre is #{cen_lat}, #{cen_lon}"

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
       


       
       
       
       @search_terms = {}
       
       @addresses
       for cached_geo_search in @submission.cached_geo_searches
         search_term = cached_geo_search.cached_geo_search_term.search_term
         if @search_terms[search_term].blank?
           @search_terms[search_term] = 1
         else
           @search_terms[search_term] = @search_terms[search_term]+1
         end
       end




       @accuracies = {}
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
         end
       end
     end
     
     #Add location markers
=begin
     for key in @locations.keys
       cached_geo_seach_array = @locations[key]
       for cached_search in cached_geo_seach_array
         @map.overlay_init(GMarker.new([cached_search.latitude, cached_search.longitude],
         :title => key.search_term, :info_window => cached_search.to_info_map_window(@submission)))
       end
     end
     
     
     
=end
    if !@submission.blank?
      @stopped_words = @submission.filtered_by('stopped')
      @removed_by_calais = @submission.filtered_by('filtered_by_calais')
      @stopped = @submission.filtered_by('stopped')
      @no_matches = @submission.filtered_by('no_geocoder_matches')
      @too_short = @submission.filtered_by('too_short')
      @geoparser_failed = @submission.filtered_by('geoparser_failed')
      
      @phrases = Phrase.find(:all, :conditions => ["words in (?)", @search_terms.keys])
      pfs = PhraseFrequency.find(
        :all,
        :conditions => ["submission_id = ? and phrase_id in (?) ", @submission.id, @phrases]
      ) 
      
      
      @phrase_frequencies = {}
      for pf in pfs
        @phrase_frequencies[pf.phrase.words] = pf.frequency
      end
    else
      
    end
    


    render :layout => 'metadata_record'

  end
  
  
  #Render those records already geoparsed
  def geoparsed
    #Check the page
    @page=1
    @page = params[:page] if !params[:page].blank?
    
    #ordering
    @order = 'content_partner, title'
    @natlib_records = NatlibMetadata.paginate :page => @page, :order => @order, :conditions => ["pending = false"]
     render :layout => 'archive_search_results'
     
  end
  
  
  
  
  #Convert area to a size
  def get_size_from_km_area(km_area)
    
    result = 15
    result = case
      when km_area == 0
        13 #May be region
      when km_area < 4
        14
      when km_area < 20
        13
      when km_area < 30
        12 # e.g.http://localhost:3000/natlib_metadatas/66096/map
      when km_area < 40
        11
      when km_area < 80
        10 # e.g. http://localhost:3000/natlib_metadatas/12509/map
      when km_area < 400
        9 #e.g. http://localhost:3000/natlib_metadatas/1231515/map
      when km_area < 800
        8
      when km_area < 3200
        7
      when km_area < 6400
        6
      when km_area < 25000
        5
      when km_area < 130000
        4 #this is nz sized
      when km_area < 250000
        3
      #Default to the whole wide world
      else
        1 #e.g. http://localhost:3000/natlib_metadatas/1328919/map
    end

     
     result
  end
end
