class ArchiveSearchesController < ApplicationController
  
  require 'digitalnz'
  DigitalNZ.api_key = DIGITAL_NZ_KEY
  
  PAGE_SIZE=20
  
  def search_form
    
  end
  
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
    
    @title = "Digital NZ - #{params[:q]}"
    
    query_hash = {}
    query_hash[:search_text] = @archive_search.search_text
    query_hash[:num_results] = "#{PAGE_SIZE}"
    query_hash[:start] = "#{PAGE_SIZE*(@page.to_i-1)}"
    query_hash[:facets] = 'category,content_partner,creator,language,rights,century,decade,year'
    @digital_nz_search_result = DigitalNZ.search(query_hash)
    @facets = @digital_nz_search_result.facets
    @facet_fields = query_hash[:facets].split(',')
    
    @num_pages = 1+@digital_nz_search_result.count/PAGE_SIZE
    
    #check metadata IDs
    new_metadata_ids = []
    @metadata_records = {}
    for result in @digital_nz_search_result.results
      nl = NatlibMetadata.find_by_natlib_id(result.id)
      if nl.blank?
        new_metadata_ids << result.id if nl.blank?
      else
        @metadata_records[result.id] = nl
      end
      
    end
    
    
    for nlid in new_metadata_ids
      nl = NatlibMetadata.parse_metadata_api(nlid)
      @metadata_records[nlid] = nl
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
