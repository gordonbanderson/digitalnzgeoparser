require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../app/helpers/geoparse_record_helper'
include GeoparseRecordHelper


class GeoparseRecordHelperTest < ActiveRecord::TestCase

    fixtures :accuracies, :filter_types

    
    
    def test_calais_80282
        parse_natlib_record(80282)
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