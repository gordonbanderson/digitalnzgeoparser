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
      CACHE.flush_all
    previous = CachedGeoSearchTerm.find_by_search_term("Aberfoyle")
    assert_equal previous, nil
    previous.destroy if !previous.blank?
    locations = parse_address("Aberfoyle")
    puts locations.to_yaml
    
    #Check for the cached search term
    search_terms = CachedGeoSearchTerm.find_by_search_term("Aberfoyle").cached_geo_searches
    puts search_terms.to_yaml
    assert_equal 6, search_terms.length
    assert_equal "Aberfoyle", search_terms[0].address

    
    #And now the cached google search result
    cached_geo_search_terms = CachedGeoSearchTerm.find(:all)
    puts cached_geo_searches.to_yaml
    assert_equal 1, cached_geo_search_terms.length
    
  end
  

  #Test NZ country bias (same as default)
  def test_springfield_nz_country_bias
      CACHE.flush_all
      search_terms = check_location_count_search_terms "Springfield",1,'nz'
      assert_equal search_terms[0].country, 'New Zealand'
  end
  
  def test_springfield_uk_country_bias
      CACHE.flush_all
      search_terms = check_location_count_search_terms "Springfield",1,'uk'
      assert_equal search_terms[0].country, 'United Kingdom'
  end
  
  #Test USA country bias
  def test_springfield_us_country_bias
      CACHE.flush_all
      search_terms = check_location_count_search_terms "Springfield",10,'us'
      
      for st in search_terms
          assert_equal 'USA',st.country
          
      end
  end
  
  
  #Eastbourne defaults to the UK unfortunately
  def test_eastbourne
      search_terms = check_location_count_search_terms "Eastbourne",1,'nz'
      assert_equal 'New Zealand',search_terms[0].country
      
  end
  
  
  def test_springfield_no_country_bias
      CACHE.flush_all
      search_terms = check_location_count_search_terms "Springfield",1,'uk'
      assert_equal 'New Zealand', search_terms[0].country
  end
  
  
  #Check that bounding boxes are correctly saved
  def test_bounding_boxes
      search_terms = check_location_count_search_terms "Wellington",1,'nz'
      wellington = search_terms[0]
      assert_equal 'New Zealand', wellington.country 
      puts wellington.to_yaml
      assert_equal -41.2948638, wellington.bbox_south
      assert_equal -41.2780951, wellington.bbox_north
      assert_equal 174.7602096, wellington.bbox_west
      assert_equal 174.7922244, wellington.bbox_east
      
      assert wellington.bbox_north > wellington.bbox_south
      assert wellington.bbox_east > wellington.bbox_west

     #Check lat/lon in bounding box
      assert wellington.bbox_west < wellington.longitude
      assert wellington.bbox_east > wellington.longitude
      assert wellington.bbox_south < wellington.latitude
      assert wellington.bbox_north > wellington.latitude
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
  
  
  
  def check_location_count_search_terms(location_name, expected_amount, bias)
      puts "Searching for #{location_name} with bias of #{bias}"
      locations = parse_address(location_name, bias)
      
      search_terms = CachedGeoSearchTerm.find_by_search_term(location_name).cached_geo_searches
      assert_equal expected_amount, search_terms.length
      search_terms
  end
  
  
  
  def test_same_location
     #Wellington Grammar School, Clifton Terrace, Wellington
     #Wellington Grammar School,  Wellington 
  end
  
  

  
end
