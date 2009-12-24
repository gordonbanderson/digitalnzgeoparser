class ArchiveSearchesController < ApplicationController
  
  require 'digitalnz'
  require 'will_paginate'
  require 'facet_fields_helper'
  
  include FacetFieldsHelper
  
  DigitalNZ.api_key = DIGITAL_NZ_KEY
  
  #Page size for any search that is not images only
  PAGE_SIZE=20
  
  #Page size for images only
  IMAGE_PAGE_SIZE=40
  
  #Parse a list of paramters in name value pairs and search the relevant facets
  # URLs can be of the form
  # * /search/fish/category/images
  # * /search/category/images/year/1920-1940
  def faceted_search
      start_time = Time.now
      
      

      #This is the case of a GET url
      prime_search_term

      @facets_hash = parse_facet_params_array params[:facets]
      
      logger.debug @facets_array.to_yaml
      

      
      leaf_facets = @facets_hash.values
      
      logger.debug "==================="
      logger.debug leaf_facets.to_yaml
      
      
      
      #FIXME - db access duplicated
      process_facet_params leaf_facets.map{|f|f.id}

      #Search digitalnz, and prime the page number, results count etc
      search_digitalnz(@archive_search.search_text, @filter_query, @page, @result_page_size)

      #Process facets for display purposes
      @facets = @digital_nz_search_result.facets    
      process_facet_fields(@facets)
      
      #Ensure hidden fields enumerate to maintain current facet
      @filter_params = leaf_facets.map{|l| l.id}

      #Render results

      respond_to do |format|
        if @archive_search.save
          flash[:archive_search] = 'Search was successfully created.'
          format.html { 
            @elapsed_time = (Time.now-start_time)*100.round.to_f / 100
            render :layout => 'archive_search_results', :template => 'archive_searches/search'
          }
          #format.xml  { render :xml => @country, :status => :created, :location => @country }
        else
          format.html { render :action => "index" }
          format.xml  { render :xml => @archive_search.errors, :status => :unprocessable_entity }
        end
      end
      
  end

  def search
    start_time = Time.now
    
    #This is the case where a search is submitted using the submit button
    #Facet fields are under the f[] param by facet field id
    if request.method == :post
        filter_ids = params[:archive_search][:filter_ids]
        @q = params[:archive_search][:search_text]
        @q = URI::unescape(@q) if !@q.blank?
        
        #Redirect, no facets
        if filter_ids.blank?
            redirect_to "/search/#{URI::escape(@q)}"
        
        #TODO - redir to nice url
        
        #Redirect to GETtable url
        else
            
            filter_param = []
            filter_ids.gsub!(' ','')
            for f in filter_ids.split(',')
                logger.debug "FPARAM:#{f}"
                if !f.blank?
                    fp = "f[]=#{f}"
                    filter_param << fp if fp !='f[]='
                end
            end
            
            logger.debug "FILTER PARAM"
            logger.debug filter_param.to_yaml
            
            
            
            redirect_to "/search/#{URI::escape(@q)}/?#{filter_param.join('&').gsub('f[]=f','')}"
            
        end
      return
    end
    
    #----------------------------------------------------------------ß
    
    #This is the case of a GET url
    prime_search_term
    
    process_facet_params params[:f]
 
    #Search digitalnz, and prime the page number, results count etc
    search_digitalnz(@archive_search.search_text, @filter_query, @page, @result_page_size)
    
    #Process facets for display purposes
    @facets = @digital_nz_search_result.facets    
    process_facet_fields(@facets)

    #Render results

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
  
  
  
  #Find similar pages by forming a query from the provided record
  def similar
      start_time = Time.now
      
      natlib_permalink = params[:id]
      @natlib_metadata = NatlibMetadata.find_by_permalink natlib_permalink
      ors = @natlib_metadata.title.split(' ').join(' AND ')
      phrase = "(#{@natlib_metadata.title})"
      @q = "\"#{@natlib_metadata.title}\"^2 OR (#{ors})"
      
        @archive_search = ArchiveSearch.new
        @archive_search.search_text = @q

        @page=1
        @page = params[:page] if !params[:page].blank?


        @archive_search.search_text = '' if @archive_search.search_text.blank?

        @title = "Digital NZ - Similar to #{params[:q]}"

        #Should be none??
        process_facet_params params[:f]

        #Search digitalnz, and prime the page number, results count etc
        search_digitalnz(@archive_search.search_text, @filter_query, @page, @result_page_size)

        #Process facets for display purposes
        @facets = @digital_nz_search_result.facets    
        process_facet_fields(@facets)

        #Render results

        respond_to do |format|
            flash[:archive_search] = 'Search was successfully created.'
            format.html { 
                @elapsed_time = (Time.now-start_time)*100.round.to_f / 100
                render :layout => 'archive_search_results', :template => 'archive_searches/search'
            }
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
    
    #Get the metatags from the db
    #FIXME - only perform query when no fragment available
    @search_term_tags = SearchTermTag.find(:all) #This is a database view
    @search_term_hash = {}
    for tag in @search_term_tags
       @search_term_hash[tag.search_text] = tag 
    end
  end
  
  
  #-- helper methods repeated in controller methods
  private
  
  #@param digitalnz_facets - facets returned from the digitalnz search
  #Sets up @child_facet_fields
  def process_facet_fields digitalnz_facets
      @parent_facets = FacetField.find(:all, :conditions =>['parent_id is null and name in (?)', digitalnz_facets])
      @child_facet_fields = {}

      #FIXME - make this more efficient
      for f in digitalnz_facets
        parent_name = f['facet_field']
        parent_facet_field = FacetField.find_by_name(parent_name)
        logger.debug "PARENT FACET:#{parent_facet_field}"
        for child_facet_name_value in f['values']
          child_facet_name = child_facet_name_value['name']
          sql_conditions = "parent_id = ? and name = ?"
          logger.debug "parent id is #{parent_facet_field.id} , child facet name is #{child_facet_name}"

          #FIXME - check for correct error conditino
          
          
          child_facet = FacetField.find_or_create_with_parent(parent_facet_field.id, child_facet_name)
          @child_facet_fields[child_facet_name] = child_facet


        end
      end 
  end
  
  
  #Prime search term, page, archive search text object from params
  def prime_search_term
      @archive_search = ArchiveSearch.new(@q)
      @archive_search.search_text = @q

      @page=1
      @page = params[:page] if !params[:page].blank?

      #If a param q is set use that for the text - nicer URL for linking around
      if !params[:q].blank?
        @archive_search.search_text = params[:q]
      end

      @archive_search.search_text = '' if @archive_search.search_text.blank?

      @title = "Digital NZ - #{params[:q]}"
  end
  
  
  #Search digitalnz with a search term and facet filter query
  def search_digitalnz(search_term, facet_filter_query,page,results_per_page)
      query_hash = {}
      @full_solr_query = search_term+facet_filter_query
      query_hash[:search_text] = @full_solr_query
      query_hash[:num_results] = "#{results_per_page}"
      query_hash[:start] = "#{results_per_page*(page.to_i-1)}"
      query_hash[:facet_num_results]='200' #Have emailed list suggesting further facets in content creator / provider categories
      query_hash[:facets] = 'category,content_partner,creator,language,rights,century,decade,year'
      @digital_nz_search_result = DigitalNZ.search(query_hash)
      @nresult_on_page = @page.to_i*@digital_nz_search_result.num_results_requested.to_i
      @nresult_on_page = @digital_nz_search_result.count if @digital_nz_search_result.count < @nresult_on_page
      @n_last_result_on_page = [@digital_nz_search_result.count, @result_page_size*@page.to_i].min
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
    
    #Create new metadata objects using values from search results
    for result in new_metadata_results
      nl = NatlibMetadata.new_from_search_result(result)
      logger.debug "NEW FROM SEARCH:#{nl.blank?}"
      @metadata_records[nl.natlib_id.to_s] = nl
    end

      #Deal with pagination
      @page_results = WillPaginate::Collection.create(
        @page, @result_page_size, @digital_nz_search_result.count) do |pager|
        start = (@page.to_i-1)*@result_page_size
      end
      
  end
  
  
  
  
  #Process the facet params
  def process_facet_params(facet_field_filter_ids)
      @filters = {}

      @filter_params = facet_field_filter_ids
      @filter_params = [] if @filter_params.blank?

      if !@filter_params.blank?
        for filter_id in @filter_params
          f = FacetField.find(filter_id)
          @filters[f.parent.name] = f
        end
      end

      #Form the basics of the current query for facetting purposes
      @previous_params = ""
      @query_term = params[:q]
      #@previous_params << "?q=#{params[:q]}"
      # PAGE NOT REQUIRED - FACETS GO BACK TO PAGE 1 @previous_params << "page=#{@page}" if @page.to_i > 1
      @previous_params << '&' if !@previous_params.blank? #This will be extended with further facets

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
  end
end
