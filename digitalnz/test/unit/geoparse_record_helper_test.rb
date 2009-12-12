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
    
    
    #| Alexander Turnbull Library |               81797 |
    #| Alexander Turnbull Library |               97680 |
    def test_duplicate_content_partners
        parse_natlib_record 81797
        n1 = NatlibMetadata.find_by_natlib_id 81797
        parse_natlib_record 97680
        n2 = NatlibMetadata.find_by_natlib_id 97680
        
        puts "T1:"+n1.content_partners.map{|s|s.name}.join(', ')
        puts "T2:"+n2.content_partners.map{|s|s.name}.join(', ')
        puts "T3"+ContentPartner.find(:all).map{|s|s.name}.join(', ')
        
        things = ContentPartner.find_all_by_name('Alexander Turnbull Library')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
        
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
    
    
    #| American Photo Company, fl 1870s-1890s             |               89766 |
    #| American Photo Company, fl 1870s-1890s             |               89765 |
    def test_duplicate_creators
        parse_natlib_record 89766
        n1 = NatlibMetadata.find_by_natlib_id 89766
        parse_natlib_record 89765
        n2 = NatlibMetadata.find_by_natlib_id 89765
        
        puts "T1:"+n1.content_partners.map{|s|s.name}.join(', ')
        puts "T2:"+n2.content_partners.map{|s|s.name}.join(', ')
        puts "T3"+Creator.find(:all).map{|s|s.name}.join(', ')
        
        things = Creator.find_all_by_name('American Photo Company, fl 1870s-1890s')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
        
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
    
    
    #Check that 2 different natlib records with the same format only create one format record
    # | Adams, E L, fl 1972                             |               81902 |
    # | Adams, E L, fl 1972                             |              108309 |
    def test_duplicate_contributors
        parse_natlib_record 81902
        n1 = NatlibMetadata.find_by_natlib_id 81902
        puts "TRACE1"
        puts Contributor.find(:all).to_yaml


        parse_natlib_record 108309
        n2 = NatlibMetadata.find_by_natlib_id 108309
        puts Contributor.find(:all).to_yaml

        puts "T1:"+n1.formats.map{|s|s.name}.join(', ')
        puts "T2:"+n2.formats.map{|s|s.name}.join(', ')
        puts "T3"+Contributor.find(:all).map{|s|s.name}.join(', ')

        contributors = Contributor.find_all_by_name('Adams, E L, fl 1972')
        assert_equal 1, contributors.length
        
        assert_equal 2, contributors[0].natlib_metadatas.length
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
    
    # Flickr                                             |             1303912 |
    #| Flickr                                             |             1302466 |
    def test_duplicate_collections
        parse_natlib_record 1303912
        n1 = NatlibMetadata.find_by_natlib_id 1303912
        parse_natlib_record 1302466
        n2 = NatlibMetadata.find_by_natlib_id 1302466
        
        puts "T1:"+n1.content_partners.map{|s|s.name}.join(', ')
        puts "T2:"+n2.content_partners.map{|s|s.name}.join(', ')
        puts "T3"+Collection.find(:all).map{|s|s.name}.join(', ')
        
        things = Collection.find_all_by_name('Flickr')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
        
    end
    
    
    #| en      |               26377 |
    #| en      |               26376 |
    def test_duplicate_languages
        parse_natlib_record 26377
        n1 = NatlibMetadata.find_by_natlib_id 26377
        parse_natlib_record 26376
        n2 = NatlibMetadata.find_by_natlib_id 26376
        
        puts "T1:"+n1.content_partners.map{|s|s.name}.join(', ')
        puts "T2:"+n2.content_partners.map{|s|s.name}.join(', ')
        puts "T3"+Language.find(:all).map{|s|s.name}.join(', ')
        
        things = Language.find_all_by_name('en')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
        
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
    
    #| Albumen photoprints |               89747 |
    #| Albumen photoprints |               76103 |
    def test_duplicate_types
        parse_natlib_record 89747
        n1 = NatlibMetadata.find_by_natlib_id 89747
        parse_natlib_record 76103
        n2 = NatlibMetadata.find_by_natlib_id 76103
        
        puts "T1:"+n1.content_partners.map{|s|s.name}.join(', ')
        puts "T2:"+n2.content_partners.map{|s|s.name}.join(', ')
        puts "T3"+Tipe.find(:all).map{|s|s.name}.join(', ')
        
        things = Tipe.find_all_by_name('Albumen photoprints')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
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
    
    
    #Subject numbers - 71,75,391
    #71 is 2025,
    #75 is 2024
    #391 is 9695
    #+------+-----------+
    #| id   | natlib_id |
    #+------+-----------+
    #| 2024 |     93865 |
    #| 2025 |     93867 |
    #| 9695 |    105255 |
    def test_duplicate_subjects
        parse_natlib_record 105255
        n1 = NatlibMetadata.find_by_natlib_id 105255
        puts "TRACE1"
        puts Subject.find(:all).to_yaml
        
        
        parse_natlib_record 93867
        n2 = NatlibMetadata.find_by_natlib_id 93867
        puts Subject.find(:all).to_yaml
        
        puts "T1:"+n1.subjects.map{|s|s.name}.join(', ')
        puts "T2:"+n2.subjects.map{|s|s.name}.join(', ')
        puts "T3"+Subject.find(:all).map{|s|s.name}.join(', ')
        
        tramping_subjects = Subject.find_all_by_name('Tramping')
        assert_equal 1, tramping_subjects.length
        
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



    #| South Island             |              110229 |
    #| South Island             |              111933 |
    def test_duplicate_coverages
        parse_natlib_record 110229
        n1 = NatlibMetadata.find_by_natlib_id 110229
        puts "TRACE1"
        puts Coverage.find(:all).to_yaml


        parse_natlib_record 111933
        n2 = NatlibMetadata.find_by_natlib_id 111933
        puts Coverage.find(:all).to_yaml

        puts "T1:"+n1.coverages.map{|s|s.name}.join(', ')
        puts "T2:"+n2.coverages.map{|s|s.name}.join(', ')
        puts "T3"+Coverage.find(:all).map{|s|s.name}.join(', ')

        coverages = Coverage.find_all_by_name('South Island')
        assert_equal 1, coverages.length
        
        assert_equal 2, coverages[0].natlib_metadatas.length
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
    
    
    
    def test_duplicate_identifiers
        parse_natlib_record 112168
        n1 = NatlibMetadata.find_by_natlib_id 112168
        puts "TRACE1"
        puts Identifier.find(:all).to_yaml


        parse_natlib_record 120263
        n2 = NatlibMetadata.find_by_natlib_id 120263
        puts Identifier.find(:all).to_yaml

        puts "T1:"+n1.identifiers.map{|s|s.name}.join(', ')
        puts "T2:"+n2.identifiers.map{|s|s.name}.join(', ')
        puts "T3"+Identifier.find(:all).map{|s|s.name}.join(', ')

        things = Identifier.find_all_by_name('C-025-023')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
    end
    
    
    def test_relations
       #272650
       parse_natlib_record 272650
       n = NatlibMetadata.find_by_natlib_id 272650
       items = n.relations
       puts items.to_yaml 
       names = items.map{|c| c.name}
       perms = items.map{|i| i.permalink}
       
       assert_equal 2, names.length
       assert names.include? 'DigitalNZ'
       assert names.include? 'http://collections.tepapa.govt.nz/db_images/digitalnzthumb.jpg?width=150&height=150&irn=88414'
 
       assert perms.include? 'digitalnz'
       assert perms.include? 'httpcollectionstepapagovtnzdb_imagesdigitalnzthumbjpgwidth150height150irn88414'
       
       parse_natlib_record 272650
       assert_equal 2, Relation.find(:all).length
    end
    
    
    #| DC-Group-0006 |              111933 |
    #| DC-Group-0006 |              112651 |
    def test_duplicate_relations
        parse_natlib_record 111933
        n1 = NatlibMetadata.find_by_natlib_id 111933
        puts "TRACE1"
        puts Relation.find(:all).to_yaml


        parse_natlib_record 112651
        n2 = NatlibMetadata.find_by_natlib_id 112651
        puts Relation.find(:all).to_yaml

        puts "T1:"+n1.relations.map{|s|s.name}.join(', ')
        puts "T2:"+n2.relations.map{|s|s.name}.join(', ')
        puts "T3"+Relation.find(:all).map{|s|s.name}.join(', ')

        things = Relation.find_all_by_name('DC-Group-0006')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
    end
    
    
    
    def test_categories
        parse_natlib_record 14687
        n = NatlibMetadata.find_by_natlib_id 14687
        cats = n.categories 
        puts cats.to_yaml
        assert_equal 'Images', cats[0].name
        assert_equal 'images', cats[0].permalink
    end
    
    
    def test_duplicate_categories
        parse_natlib_record 14686
        n1 = NatlibMetadata.find_by_natlib_id 14686

        parse_natlib_record 14687
        n2 = NatlibMetadata.find_by_natlib_id 14687

        puts "T1: "+n1.categories.map{|s|s.name}.join(', ')
        puts "T2: "+n2.categories.map{|s|s.name}.join(', ')
        puts "T3: "+Category.find(:all).map{|s|s.name}.join(', ')

        things = Category.find_all_by_name('Images')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
    end
    
    
    
    def test_rights
        parse_natlib_record 14687
        n = NatlibMetadata.find_by_natlib_id 14687
        rights = n.rights 
        puts rights.to_yaml
        assert_equal 'http://www.library.auckland.ac.nz/dbtw-wpd/gummer/about.htm', rights[0].name
        assert_equal 'httpwwwlibraryaucklandacnzdbtw-wpdgummerabouthtm', rights[0].permalink
    end
    
    
    def test_duplicate_rights
        parse_natlib_record 14686
        n1 = NatlibMetadata.find_by_natlib_id 14686

        parse_natlib_record 14687
        n2 = NatlibMetadata.find_by_natlib_id 14687

        puts "T1:"+n1.relations.map{|s|s.name}.join(', ')
        puts "T2:"+n2.relations.map{|s|s.name}.join(', ')
        puts "T3"+Right.find(:all).map{|s|s.name}.join(', ')

        things = Right.find_all_by_name('http://www.library.auckland.ac.nz/dbtw-wpd/gummer/about.htm')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
    end
    
    
    def test_placenames
       
        parse_natlib_record 14686
        n = NatlibMetadata.find_by_natlib_id 14686
        items = n.placenames
        puts items.to_yaml 
        names = items.map{|c| c.name}
        perms = items.map{|i| i.permalink}
        
        assert_equal 5, names.length
        assert names.include? 'Oceania'
        assert names.include? 'Auckland City'
        assert names.include? 'Auckland Region'
        assert names.include? 'North Island'
        assert names.include? 'New Zealand'

        assert perms.include? 'new-zealand'
        
        
    end
    
    
    #| en      |               26377 |
    #| en      |               26376 |
    def test_duplicate_placenames
        parse_natlib_record 26377
        n1 = NatlibMetadata.find_by_natlib_id 26377
        parse_natlib_record 26376
        n2 = NatlibMetadata.find_by_natlib_id 26376
        
        puts "T1:"+n1.placenames.map{|s|s.name}.join(', ')
        puts "T2:"+n2.placenames.map{|s|s.name}.join(', ')
        puts "T3"+Placename.find(:all).map{|s|s.name}.join(', ')
        
        things = Placename.find_all_by_name('Auckland Region (N.Z.)')
        assert_equal 1, things.length
        
        assert_equal 2, things[0].natlib_metadatas.length
        
    end
    
    
    def test_formats
       parse_natlib_record 102375
       n = NatlibMetadata.find_by_natlib_id 102375
       items = n.formats
       puts items.to_yaml 
       names = items.map{|c| c.name}
       perms = items.map{|i| i.permalink}
       assert names.include? '1 b&w original negative(s). Cellulosic film negative..'
       assert perms.include? '1-bw-original-negatives-cellulosic-film-negative'
    end
    
    
    #Check that 2 different natlib records with the same format only create one format record
    #| 1 b&w original negative(s). Glass negative.. Horizontal image.|              112354 |
    #| 1 b&w original negative(s). Glass negative.. Horizontal image.|              114796 |
    def test_duplicate_formats
        parse_natlib_record 112354
        n1 = NatlibMetadata.find_by_natlib_id 112354
        puts "TRACE1"
        puts Coverage.find(:all).to_yaml


        parse_natlib_record 114796
        n2 = NatlibMetadata.find_by_natlib_id 114796
        puts Format.find(:all).to_yaml

        puts "T1:"+n1.formats.map{|s|s.name}.join(', ')
        puts "T2:"+n2.formats.map{|s|s.name}.join(', ')
        puts "T3"+Format.find(:all).map{|s|s.name}.join(', ')

        formats = Format.find_all_by_name('1 b&w original negative(s). Glass negative.. Horizontal image.')
        assert_equal 1, formats.length
        
        assert_equal 2, formats[0].natlib_metadatas.length
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