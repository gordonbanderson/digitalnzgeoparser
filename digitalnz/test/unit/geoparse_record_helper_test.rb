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
        entries = CalaisEntry.find(:all)
        for entry in entries
           puts entry.pretty_print 
        end
        
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