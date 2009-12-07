require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/helpers/geoparse_record_helper'
include GeoparseRecordHelper


class GeoparseRecordHelperTest < ActiveRecord::TestCase

    fixtures :accuracies, :filter_types

    
    
    def test_calais_80282
        parse_natlib_record(80282)
        cws = CalaisWord.find(:all).map{|c|c.word}
        for cw in cws
           puts "CALAIS_WORD:*#{cw}*"
        end
        
        #Top level calais words
        assert cws.include? 'Person'
        assert cws.include? 'Facility'
        assert cws.include? 'Relations'
        assert cws.include? 'Company'
        assert cws.include? 'Country'
        
        
        #Second level
        assert cws.include? 'Tay Street'
        assert cws.include? 'Frank Arnold Coxhead'
        assert cws.include? 'New Zealand'
        assert cws.include? 'Bank of New Zealand'
        assert cws.include? 'Union Bank of Australia'
        
        #Blanks should not appear
        assert !(cws.include? '')
        
        #Check calais entries
        calais_hierachy = {}
        entries = CalaisEntry.find(:all)
        for entry in entries
            calais_hierachy[entry.parent_word.word] = [] if calais_hierachy[entry.parent_word].blank?
            calais_hierachy[entry.parent_word.word] << entry.child_word.word
           puts entry.pretty_print 
        end
        
        puts calais_hierachy['Company'].to_yaml
        
        #FIXME add company checks
        assert calais_hierachy['Person'] == ['Frank Arnold Coxhead']
    end
    
    
    #Test the creation of the content partner field, as a duplciate issue was occuring with record 76092
    def test_no_multiple_content_partner
        parse_natlib_record 76092
        n = NatlibMetadata.find_by_natlib_id(76092)
        
        puts ContentPartner.find(:all).to_yaml
        
        names = ContentPartner.find(:all).map{|c| c.name}
        
        assert  names.include? "Alexander Turnbull Library"
        assert  names.include? "Matapihi"
    end
    
    
    #Test that creators are pulled in correctly
    def test_creator
       parse_natlib_record 273830
       n = NatlibMetadata.find_by_natlib_id 273830
       names = n.creators
       puts names.to_yaml
       assert_equal 1, names.length
       assert_equal "Brake, Brian (photographer)", names[0].name
       assert_equal "brake-brian-photographer", names[0].permalink
    end
    
    #Test that contributors are stored correctly in an hatbm table
    def test_contributor
       parse_natlib_record 1319589
       n = NatlibMetadata.find_by_natlib_id 1319589
       contributors = n.contributors
       assert_equal 1, contributors.length
       assert_equal "Women's Cricket Association.", contributors[0].name
       assert_equal "womens-cricket-association", contributors[0].permalink
    end
    
    
    #Test that publishers are stored correctly in an hatbm table
    def test_publisher
       parse_natlib_record 1188492
       n = NatlibMetadata.find_by_natlib_id 1188492
       publishers = n.publishers
       
       puts Publisher.find(:all).to_yaml
       
       assert_equal 1, publishers.length
       assert_equal "University of Canterbury Library", publishers[0].name
       assert_equal "university-of-canterbury-library", publishers[0].permalink
    end
    
    
    #Test that publishers are stored correctly in an hatbm table
    def test_collection
       parse_natlib_record 1188492
       n = NatlibMetadata.find_by_natlib_id 1188492
       collections = n.collections
       
       puts Collection.find(:all).to_yaml
       
       assert_equal 1, collections.length
       assert_equal "University of Canterbury Digital Library", collections[0].name
       assert_equal "university-of-canterbury-digital-library", collections[0].permalink
    end
    
    
    #Test that languages are stored correctly in an hatbm table
    def test_language
       parse_natlib_record 27718
       n = NatlibMetadata.find_by_natlib_id 27718
       languages = n.languages
       
       puts Language.find(:all).to_yaml
       
       assert_equal 1, languages.length
       assert_equal "en", languages[0].name
       assert_equal "en", languages[0].permalink
    end
    
    
    #Test the formats which were preivously getting mangled to yaml
    def test_types
       parse_natlib_record 166667 #This record has 4 types
       n = NatlibMetadata.find_by_natlib_id 166667
       tipes = n.tipes
       type_names = tipes.map{|t| t.name}

       
       assert type_names.include? 'PhysicalObject'
       assert type_names.include? 'CulturalObject'
       assert type_names.include? 'watercolours'
       assert type_names.include? 'works of art'
       assert_equal 4, tipes.length 
    end
    
    
    #Test the formats which were preivously getting mangled to yaml
    def test_subjects
       parse_natlib_record 102379 #This record has 4 types
       n = NatlibMetadata.find_by_natlib_id 102379
       subjects = n.subjects
       puts subjects.to_yaml
       subject_names = subjects.map{|s| s.name}
       subject_perms = subjects.map{|s| s.permalink}
       
       assert_equal 6, subjects.length
       assert subject_names.include? 'Wellington Cricket Club'
       assert subject_names.include? 'Midland Cricket Club'
       assert subject_names.include? 'Basin Reserve'
       assert subject_names.include? 'Cricket matches'
       assert subject_names.include? 'Cricket - New Zealand - Wellington Region'
       assert subject_names.include? 'Cricket - Societies, etc.'
       
       assert subject_perms.include? 'basin-reserve'
       assert subject_perms.include? 'midland-cricket-club'
       assert subject_perms.include? 'wellington-cricket-club'
       assert subject_perms.include? 'cricket-matches'
       assert subject_perms.include? 'cricket-societies-etc'
       assert subject_perms.include? 'cricket-new-zealand-wellington-region'
    end
    
    
    #Check coverages for habtm
    def test_coverages
       parse_natlib_record 85367
       n = NatlibMetadata.find_by_natlib_id 85367
       coverages = n.coverages
       puts n.to_yaml 
       names = coverages.map{|c| c.name}
       assert names.include? '1950'
       assert names.include? 'Basin Reserve'
       
       assert coverages.map{|c|c.permalink}.include? 'basin-reserve'
    end
    
    def test_identifiers
       parse_natlib_record 85367
       n = NatlibMetadata.find_by_natlib_id 85367
       items = n.identifiers
       puts items.to_yaml 
       names = items.map{|c| c.name}
       perms = items.map{|i| i.permalink}
       assert names.include? 'timeframes:48156'
       assert perms.include? 'timeframes48156'
       
    end
    
    
    def test_categories
       assert_equal "NOTE TO SELF", "USED??" 
    end
    
    
    def test_nil_parsing_error
       #86556 
    end
end

=begin

118333


Person: 
- Sydney Charles Smith
City: 
- Wellington
NaturalFeature: 
- Houghton Bay
Relations:



80282

Person: 
- Frank Arnold Coxhead
Facility: 
- Tay Street
Country: 
- New Zealand
Relations: 
- ""
Company: 
- Bank of New Zealand
- Union Bank of Australia
CALAIS TAGS:


=end