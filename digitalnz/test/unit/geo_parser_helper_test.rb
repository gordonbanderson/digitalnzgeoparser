require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/helpers/geo_parser_helper'

class GeoParserHelperTest < Test::Unit::TestCase

  include GeoParserHelper
  
  
  def test_small_paragraph
    result = geoparse_text("This is a small piece of text for a test, from the city of Brighton.  What a test.")
    check_for_text_location(result,"Brighton")
  end
  

  
  def test_large_paragraph
   puts "Loading copy of station life"
   text = load_text("test/unit/station_life.txt")
   puts "Now geoparsing the text"
   geoparse_text(text)
  end
  
  #We want this test to pass even with the Unicode issue, e.g. search for Here returning Unicode chars.
  #It is desirable to keep London in the mix
  def test_unicode
    geoparse_text("London is Here") #This returns unicode terms
  end
  
  
  #Check that Canterbury in NZ can be found - by default the google geocoder returns Canterbury in England,
  #so this test checks that each search term is also searched against countries.
  def test_for_canterbury_in_nz
    result = geoparse_text("Canterbury is in New Zealand")
    assert !CachedGeoSearchTerm.find_by_search_term("Canterbury").blank?
    assert !CachedGeoSearchTerm.find_by_search_term("New Zealand").blank?
    assert !CachedGeoSearchTerm.find_by_search_term("Canterbury, New Zealand").blank?
    
  end
  
  
  #From http://localhost:3000/natlib_metadatas/26779/map
  def test_commas
    result = geoparse_text("Southland Girls High School in Tweed Street, Invercargill")
    check_for_text_location(result,"Tweed Street, Invercargill")
    check_for_text_location(result,"Southland Girls High School, Tweed Street, Invercargill")
  end
  
  
  #Test that burma is added to the list of names for myanmar
  def test_burma
    #Check burma does not exist
    burma_cn = CountryName.find_by_name("Burma")
    assert_equal nil, burma_cn
    
    size_before = CountryName.find(:all).length
    myanmar = Country.find_by_abbreviation("MM")
    before = myanmar.all_names
      
    result = geoparse_text("Burma")
    puts result.to_yaml
    after = myanmar.all_names
    
    puts before
    puts after
    
    size_after = CountryName.find(:all).length
    
    assert_equal size_before+1, size_after
    
    assert after.include?("Burma")
    
  end
  
  
  def test_cromwell
    #Check cromwell not already existing
    cgst = CachedGeoSearchTerm.find_by_search_term("Cromwell")
    assert cgst == nil
    
    result = geoparse_text("Cromwell is a town in New Zealand")
    search_terms = result.keys
    assert search_terms.length == 2
    
    assert_equal "Cromwell", search_terms[0].search_term
    assert_equal "New Zealand", search_terms[1].search_term
    
    puts search_terms[1].cached_geo_searches.length
    
    cgst = CachedGeoSearchTerm.find_by_search_term("Cromwell")
    cached_search_terms = cgst.cached_geo_searches
    assert_equal 8, cached_search_terms.length
    
  end
  
  #Performs the same search twice and ensure that the cached searches only contains one item
  def test_same_search_twice
    geoparse_text("London")
    search_terms = CachedGeoSearchTerm.find_all_by_search_term("London")
    assert_equal 1, search_terms.length
    geoparse_text("London")
    assert_equal 1, search_terms.length
  end
  
  
  def test_wales_bug
    text = load_text("test/unit/otdarticle.txt")
    result = possible_place_names(text)
    
    puts result.to_yaml
    assert !result.include?("Wales")
  end
  
  
  #Test numbers, found this bug from testing a cricket article
  def test_with_numbers
    text = load_text("test/unit/cricket.txt")
    result = possible_place_names(text)
    keys = result.keys
    puts keys.to_yaml
    assert !keys.include?("72")
    assert !keys.include?("2397")
    assert !keys.include?("47")
  end
  
  #Test numbers, found this bug from testing a cricket article
  def test_with_consecutive_caps
    text = load_text("test/unit/cricket.txt")
    result = possible_place_names(text)
    keys = result.keys
    puts keys.to_yaml
    assert keys.include?("Aaron Redmond")
    assert !keys.include?("Aaron")
    assert keys.include?("Redmond")
  end
  
  #Test apostrophes
  def test_with_apostophres
    result = possible_place_names("England's")
    keys = result.keys
    assert_equal "England", keys[0]
    assert_equal 1, keys.length
  end
  
  def test_with_zimbabwe
    result = geoparse_text("Zimbabwe")
    keys = result.keys
  end
  
  #Test numbers, found this bug from testing a cricket article
  def test_with_sentence_paragraph_boundaries
    text = load_text("test/unit/cricket2.txt")
    result = possible_place_names(text)
    keys = result.keys
    puts "CCW:#{keys.join(',')}"
    
    #This was a bug with comma separation
    assert !keys.include?("Skipper Ryan Watson Colin Smith")
    assert !keys.include?("Skipper Ryan Watson")
    assert !keys.include?("Colin Smith")
    assert !keys.include?("Colin")
    assert !keys.include?("Smith")
    assert !keys.include?("In")
    assert !keys.include?("Friends Provident Trophy")
  end
  
  
  def test_drunk_flying_women
    text = load_text("test/unit/drunk-girls.txt")
    result = possible_place_names(text)
    keys = result[0].keys
    
   
        puts result[1].to_yaml
     puts "CCW:#{keys.join(',')}"
    #Check organisations are removed
    assert !keys.include?("Reuters")
    assert !keys.include?("XL Airways")
    assert !keys.include?('Two hour') #This is caused by the text "Two-hour""


    
  end



  def test_scratch
    text = load_text("test/unit/scratch.txt")
    result = possible_place_names(text)
    keys = result[0].keys
    
    puts result[1].to_yaml
    puts "CCW:#{keys.sort.join('|')}"

    
  end
  
  
  def test_calais_query_expansion
    text = load_text("test/unit/expand.txt")
    result = possible_place_names(text)
    keys = result[0].keys
    
    puts result[1].to_yaml
    puts "CCW:#{keys.sort.join('|')}"

    
  end
  
  
  def test_corner_cases
    text = load_text("test/unit/corner-cases.txt")
    result = possible_place_names(text)
    keys = result[0].keys
    puts result[1].to_yaml
    puts "CCW:#{keys.join(',')}"  
    assert !keys.include?("Mr Ahmadinejad")
    assert !keys.include?("President Mahmoud Ahmadinejad")
  end

  
  def test_rugby_article
    text = load_text("test/unit/rugby.txt")
    result = possible_place_names(text)
    keys = result[0].keys
    
    puts "CCW:#{keys.join(',')}"
    puts result[1].to_yaml
    
    assert !keys.include?('Tuqiri')

  end
  
  def test_with_punctuation
    result = possible_place_names("Pro-China people in Hong Kong?")
    keys = result.keys
    assert_equal "Pro China", keys[0]
    assert_equal "Hong Kong", keys[1]
  end
  
  def test_with_underscores
    result = possible_place_names("This is a list of _England")
    keys = result.keys
    puts result[:possible_place_names].to_yaml
    check_for_place "England", result
  end
  
  
  def check_for_place placename, geoparse_result
      assert nil != geoparse_result[:possible_place_names][placename]
      
  end
  
  def test_the_somewhere
    result = possible_place_names("The Baghdad should simply search for the capital city")
    keys = result.keys
    puts result.to_yaml
    puts result.class
    assert_equal "Baghdad", result[:possible_place_names].keys[0]
  end
  
  
  def test_back_quotes
    result = possible_place_names("There are some backquotes in this ‘‘Should")
    keys = result.keys
    puts keys.to_yaml
    assert_equal "Should", keys[1]
  end
  
  
  def test_with_country_in_phrase
    result = possible_place_names("This England, speak of it sir.")
    keys = result.keys
    assert_equal "England", result[:possible_place_names].keys[1]
  end
  
  
  def test_with_msoft_quotes
    text = "Inscriptions for Shannon on reverse read: &#8220;Percy&#8221; and Ferry punt on Manawatu River. Steep bank indicates Shannon.&#8221; .This is Wellington"
    #text = 'This England, speak of it sir.'
    result = possible_place_names(text)
    puts result.to_yaml
    assert result[:possible_place_names].keys.include?('Shannon')
  end
  
  #Saw fail on the 88, being stripped to nothing
  def test_with_number_at_end_of_phrase
    text = "Something happened in 88, now what was it..."
    result = possible_place_names(text)
    keys = result.keys
    puts  keys.to_yaml
  end
  
  def test_comma_separation
    puts "TESTING COMMA SEPARATION"
    result = possible_place_names("Mt. Egmont as seen from Stratford, Taranaki")
    puts result[0].to_yaml
    puts "*******"
    puts result[1].to_yaml
    puts result[1].keys.to_yaml
    
    assert result[0].include?("Stratford, Taranaki")
  end
  
  def test_calais_mt_egmont
     check_text_for_place("Mt. Egmont as seen from Stratford, Taranaki", "Mt. Egmont")
  end
  
  def test_calais_mt_egmont
=begin     
     check_text_for_place("Mt. Egmont as seen from Stratford, Taranaki", ["Mt. Egmont"])
=end     
     check_text_for_place("Mount Taranaki and the township of Stratford, circa 1900. Photograph taken by James McAllister.", 
                          ["Mount Taranaki", "Stratford"])
     
  end
  
  
  def test_natlib_record
    
    #This example contains dashes "Harbours - New Zealand - Wellington Region"
    #check_record_for_place(48526, ["Wellington", "Oriental Bay", "Evans Bay"])
   # check_record_for_place(69431, ["Wellington", "Wellington City"])
    
    #check_record_for_place(61547,["Endevaour Inlet", "New Zealand"])
    #check_record_for_place(61394, ["Endeavour Inlet, Marlborough Sounds"])
    #check_record_for_place(20944, ["Christchurch Hospital, Riccarton Avenue, Christchurch "])
    check_record_for_place(26868, ['Yarrow St'])
  end
  
  
  def test_dash_in_phrase
    check_record_for_place(140793, ['Invercargill', 'Christchurch']) #This has Christchurch-Invercargill in it
  end
  
  
  def test_for_dashes
    check_text_for_place("Harbours - New Zealand - Wellington Region",["New Zealand", "Wellington Region"])
  end
  
  
  
  private
  
  #Check if the location key objets contain expected text
  def check_for_text_location(geoparse_result, name)
    assert_equal true, geoparse_result[:geohits].keys.map{|l| l.search_term}.include?(name)
  end
  
  
  
  
  #Check a record for a place
  def check_record_for_place(natlib_record_id, places)
    nl = NatlibMetadata.find_by_natlib_id(natlib_record_id)
    check_text_for_place(nl.geo_text, places)
  end
  
  def check_text_for_place(text, places)
    puts "== PLACE CHECK =="
    result = possible_place_names(text)
   
    puts "Checking for '#{places.join(',')}' in '#{text}'"
     
     for place in result[0].keys
       puts "#{place} -> #{result[0][place]}"
     end
      for place in places
         assert result[0].include?(place)
       end
  end
  
  
  
  
  
end