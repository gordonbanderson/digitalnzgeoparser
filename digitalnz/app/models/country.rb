class Country < ActiveRecord::Base
  
  has_many :country_names
  
  validates_uniqueness_of :abbreviation
  
  has_many :submission_country_filters
  has_many :submissions, :through => :submission_country_filters
  
  
  def search_terms_for_submission(submission)
    all_search_terms_for_submission = SearchTermFrequency.find_by_submission_id(submission.id)
    term_ids = all_search_terms_for_submission.map{|sf| sf.cached_geo_search_term_id }
    #FIXME - use foreign key for countries
    all_cached_searches_for_country = CachedGeoSearchTerm.find(:all, 
        :conditions => ["cached_geo_search_term_id in (?) and country = ?", term_ids,  abbreviation])
    
    all_cached_searches_for_country
  end
  
  
  def search_terms_for_submission_as_string(submission)
    all_cached_searches_for_country = search_terms_for_submission(submission)
    
  end
  
  
  def all_names
    country_names.map{|cn| cn.name}.sort.join(', ')
  end
end
