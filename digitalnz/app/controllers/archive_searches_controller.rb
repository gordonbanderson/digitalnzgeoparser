class ArchiveSearchesController < ApplicationController
  
  require 'digitalnz'
  require 'will_paginate'
  DigitalNZ.api_key = DIGITAL_NZ_KEY
  
  #Page size for any search that is not images only
  PAGE_SIZE=20
  
  #Page size for images only
  IMAGE_PAGE_SIZE=20
  

  def search
    start_time = Time.now
    @archive_search = ArchiveSearch.new(params[:archive_search])
    
    if request.method == :post
      redirect_to search_archive_searches_url(:q=>@archive_search.search_text)
      return
    end
    
    @page=1
    @page = params[:page] if !params[:page].blank?
    
    #If a param q is set use that for the text - nicer URL for linking around
    if !params[:q].blank?
      @archive_search.search_text = params[:q]
    end
    
    @archive_search.search_text = '' if @archive_search.search_text.blank?
    
    @title = "Digital NZ - #{params[:q]}"
    
    @filters = {}
    
    @filter_params = params[:f]
    @filter_params = {} if @filter_params.blank?
    
    if !@filter_params.blank?
      for filter_id in @filter_params
        f = FacetField.find(filter_id)
        @filters[f.parent.name] = f
      end
    end
    
    #Form the basics of the current query for facetting purposes
    @previous_params = ""
    @query_term = params[:q]
    @previous_params << "?q=#{params[:q]}"
    @previous_params << "&page=#{@page}"
    
    #If we have any filters we need to expand the query
    @filter_query = ""
    
    #Also create URL params to append to facet links to drill down
    @facet_params_chosen=''
    @images_category = false  # True if images category selected
    for filter in @filters.values
      filter_parent_name = filter.parent.name
      filter_name = filter.name
      @filter_query << ' '
      @filter_query << "#{filter_parent_name}:\"#{filter_name}\""
      @facet_params_chosen << "&f[]=#{filter.id}"
      @images_category = true if filter_name == 'Images'
    end
    
    #Do the search
    @result_page_size = PAGE_SIZE
    if @images_category
      @result_page_size = IMAGE_PAGE_SIZE
    end
    
    
    
    query_hash = {}
    @full_solr_query = @archive_search.search_text+@filter_query
    query_hash[:search_text] = @full_solr_query
    query_hash[:num_results] = "#{@result_page_size}"
    query_hash[:start] = "#{@result_page_size*(@page.to_i-1)}"
    query_hash[:facet_num_results]='50000'
    query_hash[:facets] = 'category,content_partner,creator,language,rights,century,decade,year'
    @digital_nz_search_result = DigitalNZ.search(query_hash)
    @facets = @digital_nz_search_result.facets
    @facet_fields = query_hash[:facets].split(',')
    
    @nresult_on_page = @page.to_i*@digital_nz_search_result.num_results_requested.to_i
    @nresult_on_page = @digital_nz_search_result.count if @digital_nz_search_result.count < @nresult_on_page
    
    
    @parent_facets = FacetField.find(:all, :conditions =>['parent_id is null and name in (?)', @facet_fields])
    @child_facet_fields = {}
=begin
<%for facet in @facets%>
  <div class="facetField">
  <h5><%=facet['facet_field'].camelize%></h5>
  <ul>
      <%for value in facet['values']%>
      <li>
          <%=value['name']%> (<%=value['num_results']%>)

=end
    #FIXME - make this more efficient
    for f in @facets
      parent_name = f['facet_field']
      parent_facet_field = FacetField.find_by_name(parent_name)
      logger.debug "PARENT FACET:#{parent_facet_field}"
      for child_facet_name_value in f['values']
        child_facet_name = child_facet_name_value['name']
        sql_conditions = "parent_id = ? and name = ?"
        logger.debug "parent id is #{parent_facet_field.id} , child facet name is #{child_facet_name}"

        #FIXME - check for correct error conditino
        
          child_facet_field = FacetField.find(:first, 
            :conditions => [sql_conditions, parent_facet_field.id, child_facet_name]
          )
          
        #Create this if it does not exist
        
          if child_facet_field.blank?
            child_facet_field = FacetField::create :parent_id => parent_facet_field.id, :name => child_facet_name
            child_facet_field.save!
          end
        

        @child_facet_fields[child_facet_name] = child_facet_field
        
        
      end
    end
    
    @num_pages = 1+@digital_nz_search_result.count/@result_page_size
    
    #check metadata IDs
    new_metadata_results = []
    @metadata_records = {}
    for result in @digital_nz_search_result.results
      logger.debug "RESULT:"
      logger.debug result.to_yaml
      nl = NatlibMetadata.find_by_natlib_id(result.id)
      if nl.blank?
        new_metadata_results << result if nl.blank?
      else
        @metadata_records[result.id] = nl
      end
      
    end
    
    
    for result in new_metadata_results
      nl = NatlibMetadata.new_from_search_result(result)
      logger.debug "NEW FROM SEARCH:#{nl.blank?}"
      @metadata_records[nl.natlib_id.to_s] = nl
    end


    #Deal with pagination
    @page_results = WillPaginate::Collection.create(
      @page, @result_page_size, @digital_nz_search_result.count) do |pager|
      start = (@page.to_i-1)*@result_page_size
      #pager.replace(@digital_nz_search_result.results.to_array[start, result_page_size])
    end

=begin
num_results - the number of results the user wishes returned
start - the offset from which the result list should start
sort - the field upon which results are sorted. If sort_field isn't specified the results are sorted by relevance. The sort_field must be one of: category, content_provider, date, syndication_date, title
direction - the direction in which the results are sorted. Can only be used in conjunction with the sort field and must be either asc or desc. If not specified, sort_direction defaults to asc
facets - a list of facet fields to include in the output. See the note on facets below for more information.
facet_num_results - the number of facet results to include. Only used if the facets parameter is specified, and defaults to 10.
facet_start - the offset from which the facet value list should start. Only used if the facets parameter is specified, and defaults to 0.


category, content_partner, creator, language, rights, century, decade, and year.
=end
    
    respond_to do |format|
      if @archive_search.save
        flash[:archive_search] = 'Search was successfully created.'
        format.html { 
          @elapsed_time = (Time.now-start_time)*100.round.to_f / 100
          render :layout => 'archive_search_results'
        }
        #format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @archive_search.errors, :status => :unprocessable_entity }
      end
    end
    

  end
  
  
  def show
    @q = params[:q]
    @search_params = {:search_text => @q}
    @digital_nz_search_result = DigitalNZ.search(@q)
    
  end
  
  def index
    #We just want to render a form here
    @archive_search = ArchiveSearch::new
  end
end
