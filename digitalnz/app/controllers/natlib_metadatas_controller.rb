class NatlibMetadatasController < ApplicationController
  require 'will_paginate'
  require 'cgi'
  
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
    permalink = params[:permalink]
    if !permalink.blank?
        @natlib_metadata = NatlibMetadata.find_by_permalink(permalink)
    else
        id_string = params[:id].split('-')[0]
        @natlib_metadata = NatlibMetadata.find_by_natlib_id(id_string)
    end
    
    #If still not found, download from Digital NZ
    if @natlib_metadata.blank?
        @natlib_metadata = NatlibMetadata.update_or_create_metadata_from_api(id_string)
    end


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
       
       #This will hold a mapping of the current cached geo search to the N nearest ones
       #These will be rendered in the HTML map popups
       @nearby_locations = {}

       @calais_hash = {}
       if @n_places_found > 0
         # if the submission area is small, zoom in more
  
            
            @search_terms = {}

            for cached_geo_search in @submission.cached_geo_searches
                for search_term in cached_geo_search.cached_geo_search_terms.map{|c|c.search_term}
                     if @search_terms[search_term].blank?
                        @search_terms[search_term] = 1
                      else
                        @search_terms[search_term] = @search_terms[search_term]+1
                      end
                end
             #search_term = cached_geo_search.cached_geo_search_term.search_term
             
            end
            
            
            @stopped_words = @submission.filtered_by('stopped')
            @removed_by_calais = @submission.filtered_by('filtered_by_calais')
            @stopped = @submission.filtered_by('stopped')
            @no_matches = @submission.filtered_by('no_geocoder_matches')
            @too_short = @submission.filtered_by('too_short')
            @geoparser_failed = @submission.filtered_by('geoparser_failed')
            
            #Form a hash of calais parent to calais_child
            @calais_hash = {}
            for entry in @submission.calais_entries
                @calais_hash[entry.parent_word]=[] if @calais_hash[entry.parent_word].blank?
                @calais_hash[entry.parent_word] << entry.child_word
            end
            

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
              
              @n_places_for_terms = {}

              for cached_search in @submission.cached_geo_searches
                  for cg_search_term in cached_search.cached_geo_search_terms
                      search_term = cg_search_term.search_term
                      
                      #Only add a marker if there is a phrase match, otehrwise we will get all the
                      #search phrases that match, e.g. 'Hataitai', 'Hataitai, Wellington' etc
                      #Makes for a bushy map
                      next if !@phrases.include? search_term
                        @n_places_for_terms[search_term] = 0 if @n_places_for_terms[search_term].blank?
                        @n_places_for_terms[search_term] = @n_places_for_terms[search_term] + 1
                      if cached_search.accuracy.google_id < @filter.to_i
                        info_text = '<div class="mapInfo">'
                        info_text << cached_search.address
                        info_text << '<br/>'
                        info_text << cached_search.accuracy.name
                        info_text << ':'
                        info_text << '"'+search_term+'"'
                        
                        info_text << '<br/>Nearby:'
                        nearby_locations = cached_search.find_all_within_km_radius(1)
                        @nearby_locations[cached_search] = nearby_locations
                        ctr = 0
                        duplicate_addresses = {}
                        for l in nearby_locations
                          splits = l.address.split(',')
                          crunched_address = splits[0]
                          place_search = [splits[0], splits[1]].join(',')
                          if duplicate_addresses[place_search].blank?
                            duplicate_addresses[place_search]=place_search
                            distance = NatlibMetadatasHelper.pretty_distance 1000*l.distance.to_f
                            info_text << '<a href="/search/'+ URI.encode(place_search)+'">'+crunched_address+"</a>&nbsp;(#{distance})"+'&nbsp;'
                            ctr = ctr + 1
                          end
                         
                          break if ctr > 20 #Limit to 6
                        end
                        
                        info_text << "</div>"
                             @accuracies[search_term] = cached_search.accuracy.name
                        @map.overlay_init(GMarker.new([cached_search.latitude, cached_search.longitude],
                         :title => search_term,
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
            
            if @maxx.blank? && maxy.blank?
                logger.debug "TRACE: Defaulting to the whole world as both yahoo and google cannot provide info"
                @size = 4
                @map.center_zoom_init([0,0], @size)
                @accuracies = {}
                @phrases = []
            else
                @area_lat_lon = (maxx-minx)*(maxy-miny)

                 @size = get_size_from_km_area miny, minx, maxy, maxx
                 @center = [(miny+maxy)*0.5, (minx+maxx)*0.5 ]
                 @map.center_zoom_init(@center, @size)
            end
            
 

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
           @map.center_zoom_init([0,0], @size) if !@map.blank?
         
         end
      end
       


       
       
       





     
     


     
    
    @all_accuracies = Accuracy.find(:all, :order => :id)
    @inverted_accuracies = @accuracies.invert if !@accuracies.blank?
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
    def generic_properties
        property = params[:property_plural].singularize
        natlib_properties property
    end
    
    
    #Display a list of natlib results for said address
    def generic_property
        property = params[:property_name]
        logger.debug "PROP:#{property}"
        logger.debug params.to_yaml
        natlib_property property
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

    
    #These are the ids that are on the current page
    @paged_natlib_records = GeoparsedRecord.paginate :page => @page, :order => @order, :conditions => conditions, :per_page => PAGE_SIZE
    @the_ids = @paged_natlib_records.map{|p|p.natlib_id.to_i}
    @natlib_metadatas = NatlibMetadata.find(:all, :conditions => ["natlib_id in (?)", @the_ids])

    #Work out page metainfo
	@start_count = 1+(@paged_natlib_records.current_page-1) * PAGE_SIZE
	@finish_count = PAGE_SIZE * @paged_natlib_records.current_page
	@finish_count = @paged_natlib_records.total_entries if @paged_natlib_records.total_entries < @finish_count
	@total_count = @paged_natlib_records.total_entries
	
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
 
 
=begin
select  n.id, ces.calais_entry_id
from submissions s
inner join natlib_metadatas n
on (s.natlib_metadata_id = n.id)
inner join calais_entries_submissions ces
on (ces.submission_id = s.id)
where ces.calais_entry_id = 480
order by n.title;

=end
  
  def calais_child
    @page = 1
    @page = params[:page] if !params[:page].blank?
    parent_perm = params[:parent_permalink]
    child_perm = params[:child_permalink]
    @calais_parent_word = CalaisWord.find_by_permalink parent_perm
    @calais_child_word = CalaisWord.find_by_permalink child_perm
    @calais_entry = CalaisEntry.find(:first, :conditions =>
        ["calais_parent_word_id = ? and calais_child_word_id = ?",
            @calais_parent_word.id, @calais_child_word.id
        ]
    )
    
    @property = @calais_entry
    @clazz = CalaisEntry

    sql_count = <<-EOF
    select  count(n.id)
      from submissions s
      inner join natlib_metadatas n
      on (s.natlib_metadata_id = n.id)
      inner join calais_entries_submissions ces
      on (ces.submission_id = s.id)
      where ces.calais_entry_id = ?    
    EOF
    
    sql_find = <<-EOF
      select  n.*
      from submissions s
      inner join natlib_metadatas n
      on (s.natlib_metadata_id = n.id)
      inner join calais_entries_submissions ces
      on (ces.submission_id = s.id)
      where ces.calais_entry_id = ?
      order by n.title
     EOF
     
    sql_find << " limit #{PAGE_SIZE} offset #{(@page.to_i-1)*PAGE_SIZE} "
    
    @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
    
    #FIXME - any risk of SQL injection here?
    @natlib_metadatas = NatlibMetadata.find_by_sql(sql_find.gsub('?', @calais_entry.id.to_s))

    @total_count = NatlibMetadata.count_by_sql sql_count.gsub('?', @calais_entry.id.to_s)
    @debug = sql_count.gsub('?', @calais_entry.id.to_s)
    @n_pages = 1+@total_count/PAGE_SIZE


    @single_name =  'Open Calais'
    @plural_name = 'Open Calais'

  
    
    #Deal with pagination
    @page_results = WillPaginate::Collection.create(
      @page, 
      PAGE_SIZE, 
      @total_count) do |pager|
      start = (@page.to_i-1)*PAGE_SIZE
    end
    render :template => 'shared/property', :layout => 'archive_search_results' 
  end
  
  
  def calais_parent
        @clazz = CalaisEntry
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        parent_perm = params[:parent_permalink]
        @calais_parent_word = CalaisWord.find_by_permalink parent_perm

        sql_find = <<-EOF
          select cw.id, cw.word,cw.permalink from
          calais_entries ce
          inner join calais_words cw
          on (cw.id = ce.calais_child_word_id)
          where ce.calais_parent_word_id = ?
          order by cw.word
        EOF
        sql_find << " limit #{TEXT_LISTPAGE_SIZE} offset #{(@page.to_i-1)*TEXT_LISTPAGE_SIZE} "
 
        sql_count = <<-EOF
        select  count(cw.id) from
          calais_entries ce
          inner join calais_words cw
          on (cw.id = ce.calais_child_word_id)
          where ce.calais_parent_word_id = ?  
        EOF
        
        
        @properties = CalaisWord.find_by_sql(sql_find.gsub('?', @calais_parent_word.id.to_s))
        
        @total_count = CalaisWord.count_by_sql sql_count.gsub('?', @calais_parent_word.id.to_s)
               
        @page_results = WillPaginate::Collection.create(
             @page, 
             TEXT_LISTPAGE_SIZE, 
             @total_count) do |pager|
             start = (@page.to_i-1)*TEXT_LISTPAGE_SIZE
           end
           
        @n_pages = 1+@total_count/TEXT_LISTPAGE_SIZE
        
        @single_name = 'Open Calais'
        @plural_name = 'Open Calais'
      render :template => 'shared/open_calais_parent_known', :layout => 'archive_search_results'
  end
  
  
  def calais_all_parents
      sql = <<-EOF
        select distinct calais_parent_word_id, cw.word, cw.permalink from calais_entries
        inner join calais_words cw
        on (calais_parent_word_id = cw.id)
        order by cw.word
      EOF
      @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
      
      @calais_parent_words = CalaisWord.find_by_sql(sql)
      render :template => 'shared/open_calais_all_parents', :layout => 'archive_search_results'
      
  end
  
  
  
  #Helper methods for the controller, made private so they cannot be called directly
  #Display a list of all coverages
  #@param propertyname - name of a property, e.g. coverage
  def natlib_properties(property_name)
        @clazz = property_name.camelize.constantize
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        @properties = @clazz.paginate :select => 'name,permalink', :page => @page, :order => 'name', :per_page => TEXT_LISTPAGE_SIZE
        @n_pages = 1+@properties.total_entries/TEXT_LISTPAGE_SIZE
        
        @single_name = single_name property_name
        @plural_name = plural_name property_name
      render :template => 'shared/properties', :layout => 'archive_search_results'
  end
  
  #Render a single property, e.g. a coverage of 'Wellington' or a subject of 'Trains'
  def natlib_property(property_name)
        @clazz = property_name.camelize.constantize
        @single_name = single_name property_name
        @plural_name = plural_name property_name
        @page = 1
        @page = params[:page] if !params[:page].blank?
        @archive_search = ArchiveSearch::new #maintain a happy empty search form at the top of the page
        permalink = params[:permalink]
        @property = @clazz.find_by_permalink(permalink)
        @natlib_metadatas = @property.natlib_metadatas.paginate :page => @page, :order => 'title', :per_page => PAGE_SIZE
        @n_pages = 1+@natlib_metadatas.total_entries/TEXT_LISTPAGE_SIZE

        render :template => 'shared/property', :layout => 'archive_search_results' 
  end
  
  def single_name property
      result = property.titleize.singularize
      result.gsub! 'Tipe', 'Type'
      result
  end
  
  def plural_name property
      single_name(property).pluralize
  end
end
