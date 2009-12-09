require File.dirname(__FILE__) + '/../test_helper'

class NoDuplicationTest < ActiveSupport::TestCase

=begin
has_and_belongs_to_many :content_partners
has_and_belongs_to_many :creators
has_and_belongs_to_many :contributors
has_and_belongs_to_many :publishers
has_and_belongs_to_many :collections
has_and_belongs_to_many :languages
has_and_belongs_to_many :tipes
has_and_belongs_to_many :subjects
has_and_belongs_to_many :coverages
has_and_belongs_to_many :categories
has_and_belongs_to_many :identifiers
has_and_belongs_to_many :formats
has_and_belongs_to_many :placenames
has_and_belongs_to_many :rights
has_and_belongs_to_many :relations
=end

    #Check several classes for non duplication of names
    def test_no_duplicate_names
        for class_name in [
            'Category',
            'ContentPartner',
            'Contributor',
            'Coverage',
            'Collection',
            'Format',
            'Identifier',
            
            
            'Subject',
            'Tipe',
            'Language',
            'Placename',
            'Publisher',
            'Relation',
            'Right',
            'Subject'
            ]
            
            clazz = class_name.constantize
            c1 = clazz.send('create', {:name => 'Test Duplication'})
            begin
                c2 = clazz.send('create', {:name => 'Test Duplication'})
                fail "Duplication should not happen"
                #This should fail
            rescue
                assert_equal nil, c2
            end
        end
    end
end