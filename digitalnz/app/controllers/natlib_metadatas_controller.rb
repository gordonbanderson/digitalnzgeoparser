class NatlibMetadatasController < ApplicationController
  
  
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

       
       if !@centroid.blank?
         
         @size = EXTENT_SIZE[@centroid.extent_type]
         
         
         # if the submission area is small, zoom in more
         if !@submission.blank?
           
           #Deal with size
           if !@submission.area.blank?
             @size = get_size_from_km_area(@submission.area)
           end
           
           #Deal with centre of points
           
         end
         
         logger.debug(@centroid.extent_type)
         @map.center_zoom_init([@centroid.latitude,@centroid.longitude], @size)
       else
         @size = 4
         @map.center_zoom_init([0,0], @size)
         
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
    else
      
    end
    


    render :layout => 'metadata_record'

  end
  
  
  
  
  #Convert area to a size
  def get_size_from_km_area(km_area)
    result = 15
     if km_area < 10
       result=9
     elsif km_area < 20
       result = 10
     end
     
     result
  end
end
