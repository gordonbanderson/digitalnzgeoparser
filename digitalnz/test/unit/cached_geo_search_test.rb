require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/helpers/geography_helper'

include GeographyHelper

class CachedGeoSearchTest < ActiveSupport::TestCase
    
  
  
  #Test the street level accuracy
  def test_street_level_for_geocoding
    street = Accuracy.find_by_name("Street")
    assert_not_nil street
    search_term = CachedGeoSearch.find(:first, :conditions => ["accuracy_id = ?", street.id])
    assert_not_nil search_term
    
    #streets are not significant
    assert_equal false, search_term.is_significant_for_geocoding?
    
    #Countries do count
    country = Accuracy.find_by_name("Country")
    search_term = CachedGeoSearch.find(:first, :conditions => ["accuracy_id = ?", country.id])
    assert_equal true, search_term.is_significant_for_geocoding?
  end
  
  # Replace this with your real tests.
  def test_valid_uncached_search
    previous = CachedGeoSearchTerm.find_by_search_term("Aberfoyle")
    previous.destroy if !previous.blank?
    locations = parse_address("Aberfoyle, Scotland")
    puts locations.to_yaml
    
    #Check for the cached search term
    search_terms = CachedGeoSearchTerm.find(:all)
    puts search_terms.to_yaml
    assert_equal 1, search_terms.length
    assert_equal "Aberfoyle, Scotland", search_terms[0].search_term
    
    #And now the cached google search result
    cached_geo_searches = CachedGeoSearch.find(:all)
    puts cached_geo_searches.to_yaml
    assert_equal 1, cached_geo_searches.length
    
  end
  
  
  def test_no_admin_area
    locations = parse_address("All")
    puts locations.to_yaml
    
    #Check for the cached search term
    search_terms = CachedGeoSearchTerm.find(:all)
    assert_equal 1, search_terms.length
    assert_equal "Aberfoyle", search_terms[0].search_term
    
    #And now the cached google search result
    cached_geo_searches = CachedGeoSearch.find(:all)
    assert_equal 5, cached_geo_searches.length
    
  end
  
  def test_valid_cached_search
    previous = CachedGeoSearchTerm.find_by_search_term("Aberfoyle")
    previous.destroy if !previous.blank?
    result = parse_address("Aberfoyle")
    #result is now cached
    result = parse_address("Aberfoyle")
    assert result.failed == false
  end
  
  def test_invalid_uncached_search
    previous = CachedGeoSearchTerm.find_by_search_term("aowsufoasduif")
    previous.destroy if !previous.blank?
    result = parse_address("aowsufoasduif")
    puts result.to_yaml
    
    assert result.failed == false #This is true to say the google geocoder did not failß
  end
  
  def test_invalid_cached_search
    previous = CachedGeoSearchTerm.find_by_search_term("aowsufoasduif")
    previous.destroy if !previous.blank?
    result = parse_address("aowsufoasduif")
    #result is now cached
    result = parse_address("aowsufoasduif")
    assert result.failed == false
  end
  
  def test_small_search
    result = parse_address("A")
  end
  
  

  
end
