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
    def test_no_multiple_creator
        parse_natlib_record 76092
        n = NatlibMetadata.find_by_natlib_id(76092)
        assert_equal "Alexander Turnbull Library", n.content_partner
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