class FkeysJoinTables < ActiveRecord::Migration
  def self.up
          
     #filtered_phrases_submissions
       change_table :filtered_phrases_submissions do |t|
           t.foreign_key :filtered_phrases
           t.foreign_key :submissions
       end

       #formats_natlib_metadatas
       change_table :formats_natlib_metadatas do |t|
           t.foreign_key :formats
           t.foreign_key :natlib_metadatas
       end

       #identifiers_natlib_metadatas
       change_table :identifiers_natlib_metadatas do |t|
           t.foreign_key :identifiers
           t.foreign_key :natlib_metadatas
       end

       #languages_natlib_metadatas
       change_table :languages_natlib_metadatas do |t|
           t.foreign_key :languages
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_placenames
       change_table :natlib_metadatas_placenames do |t|
           t.foreign_key :placenames
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_placenames
       change_table :natlib_metadatas_publishers do |t|
           t.foreign_key :publishers
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_placenames
       change_table :natlib_metadatas_relations do |t|
           t.foreign_key :relations
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_placenames
       change_table :natlib_metadatas_rights do |t|
           t.foreign_key :rights
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_subjects
       change_table :natlib_metadatas_subjects do |t|
           t.foreign_key :subjects
           t.foreign_key :natlib_metadatas
       end

       #natlib_metadatas_tipes
       change_table :natlib_metadatas_tipes do |t|
           t.foreign_key :tipes
           t.foreign_key :natlib_metadatas
       end


     change_table :cached_geo_searches_submissions do |t|
         t.foreign_key :cached_geo_searches
         t.foreign_key :submissions
     end


     #calais_entries_submissions
     change_table :calais_entries_submissions do |t|
         t.foreign_key :calais_entries
         t.foreign_key :submissions
     end

     #categories_natlib_metadatas
     change_table :categories_natlib_metadatas do |t|
         t.foreign_key :categories
         t.foreign_key :natlib_metadatas
     end

     #collections_natlib_metadatas
     change_table :collections_natlib_metadatas do |t|
         t.foreign_key :collections
         t.foreign_key :natlib_metadatas
     end


      #content_partners_natlib_metadatas
       change_table :content_partners_natlib_metadatas do |t|
           t.foreign_key :content_partners
           t.foreign_key :natlib_metadatas
       end

       #contributors_natlib_metadatas
       change_table :contributors_natlib_metadatas do |t|
           t.foreign_key :contributors
           t.foreign_key :natlib_metadatas
       end

       #coverages_natlib_metadatas
       change_table :coverages_natlib_metadatas do |t|
           t.foreign_key :coverages
           t.foreign_key :natlib_metadatas
       end

       #contributors_natlib_metadatas
       change_table :creators_natlib_metadatas do |t|
           t.foreign_key :creators
           t.foreign_key :natlib_metadatas
       end

       #Add indexes to join tables
         add_index :natlib_metadatas, :pending
         add_index :filtered_phrases_submissions, :filtered_phrase_id
         add_index :filtered_phrases_submissions, :submission_id
         add_index :cached_geo_searches_submissions, :cached_geo_search_id
         add_index :cached_geo_searches_submissions, :submission_id
         add_index :formats_natlib_metadatas, :format_id
         add_index :formats_natlib_metadatas, :natlib_metadata_id
         add_index :identifiers_natlib_metadatas, :identifier_id
         add_index :identifiers_natlib_metadatas, :natlib_metadata_id
         add_index :languages_natlib_metadatas, :language_id
         add_index :languages_natlib_metadatas, :natlib_metadata_id
         add_index :natlib_metadatas_placenames, :placename_id
         add_index :natlib_metadatas_placenames, :natlib_metadata_id
         add_index :natlib_metadatas_publishers, :publisher_id
         add_index :natlib_metadatas_publishers, :natlib_metadata_id
         add_index :natlib_metadatas_relations, :relation_id
         add_index :natlib_metadatas_relations, :natlib_metadata_id
         add_index :natlib_metadatas_rights, :right_id
         add_index :natlib_metadatas_rights, :natlib_metadata_id
         add_index :natlib_metadatas_subjects, :subject_id
         add_index :natlib_metadatas_subjects, :natlib_metadata_id
         add_index :natlib_metadatas_tipes, :tipe_id
         add_index :natlib_metadatas_tipes, :natlib_metadata_id
         add_index :categories_natlib_metadatas, :category_id
         add_index :categories_natlib_metadatas, :natlib_metadata_id
         add_index :collections_natlib_metadatas, :collection_id
         add_index :collections_natlib_metadatas, :natlib_metadata_id
         add_index :content_partners_natlib_metadatas, :content_partner_id
         add_index :content_partners_natlib_metadatas, :natlib_metadata_id
         add_index :contributors_natlib_metadatas, :contributor_id
         add_index :contributors_natlib_metadatas, :natlib_metadata_id
         add_index :coverages_natlib_metadatas, :coverage_id
         add_index :coverages_natlib_metadatas, :natlib_metadata_id
         add_index :creators_natlib_metadatas, :creator_id
         add_index :creators_natlib_metadatas, :natlib_metadata_id
    end

  def self.down
  end
end

