# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100115005603) do

  create_table "accuracies", :force => true do |t|
    t.column "name", :string
    t.column "google_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "accuracies", ["google_id"], :name => "index_accuracies_on_google_id"

  create_table "archive_searches", :force => true do |t|
    t.column "search_text", :string
    t.column "num_results_request", :integer
    t.column "page", :integer
    t.column "elapsed_time", :float
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "cached_geo_search_terms", :force => true do |t|
    t.column "search_term", :string
    t.column "failed", :boolean
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "is_country", :boolean
  end

  add_index "cached_geo_search_terms", ["search_term"], :name => "index_cached_geo_search_terms_on_search_term"

  create_table "cached_geo_search_terms_cached_geo_searches", :id => false, :force => true do |t|
    t.column "cached_geo_search_id", :integer
    t.column "cached_geo_search_term_id", :integer
  end

  add_index "cached_geo_search_terms_cached_geo_searches", ["cached_geo_search_id"], :name => "cached_geo_search_id"
  add_index "cached_geo_search_terms_cached_geo_searches", ["cached_geo_search_term_id"], :name => "cached_geo_search_term_id"

  create_table "cached_geo_searches", :force => true do |t|
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "admin_area", :string
    t.column "subadmin_area", :string
    t.column "dependent_locality", :string
    t.column "locality", :string
    t.column "accuracy_id", :integer
    t.column "country", :string
    t.column "address", :string
    t.column "permalink", :string
    t.column "geom", :point, :null => false
    t.column "signature", :string
    t.column "latitude", :decimal, :precision => 15, :scale => 10
    t.column "longitude", :decimal, :precision => 15, :scale => 10
    t.column "bbox_west", :decimal, :precision => 15, :scale => 10
    t.column "bbox_south", :decimal, :precision => 15, :scale => 10
    t.column "bbox_north", :decimal, :precision => 15, :scale => 10
    t.column "bbox_east", :decimal, :precision => 15, :scale => 10
    t.column "metaphone1", :string
    t.column "metaphone2", :string
  end

  add_index "cached_geo_searches", ["permalink"], :name => "index_cached_geo_searches_on_permalink", :unique => true
  add_index "cached_geo_searches", ["accuracy_id"], :name => "cached_geo_searches_accuracy_id_fk"
  add_index "cached_geo_searches", ["geom"], :name => "index_cached_geo_searches_on_geom"

  create_table "cached_geo_searches_cached_geo_search_terms", :force => true do |t|
    t.column "cached_geo_search_id", :integer
    t.column "cached_geo_search_term_id", :integer
  end

  add_index "cached_geo_searches_cached_geo_search_terms", ["cached_geo_search_id"], :name => "index_cgs_join1_id"
  add_index "cached_geo_searches_cached_geo_search_terms", ["cached_geo_search_term_id"], :name => "index_cgs_join2_id"

  create_table "cached_geo_searches_submissions", :id => false, :force => true do |t|
    t.column "submission_id", :integer
    t.column "cached_geo_search_id", :integer
  end

  add_index "cached_geo_searches_submissions", ["cached_geo_search_id"], :name => "index_cached_geo_searches_submissions_on_cached_geo_search_id"
  add_index "cached_geo_searches_submissions", ["submission_id"], :name => "index_cached_geo_searches_submissions_on_submission_id"

  create_table "calais_entries", :force => true do |t|
    t.column "calais_child_word_id", :integer
    t.column "calais_parent_word_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "calais_entries", ["calais_child_word_id"], :name => "calais_entries_calais_child_word_id_fk"
  add_index "calais_entries", ["calais_parent_word_id"], :name => "calais_entries_calais_parent_word_id_fk"

  create_table "calais_entries_submissions", :id => false, :force => true do |t|
    t.column "calais_entry_id", :integer
    t.column "submission_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "calais_entries_submissions", ["calais_entry_id"], :name => "calais_entries_submissions_calais_entry_id_fk"
  add_index "calais_entries_submissions", ["submission_id"], :name => "calais_entries_submissions_submission_id_fk"

  create_table "calais_submissions", :force => true do |t|
    t.column "signature", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "calais_submissions", ["signature"], :name => "index_calais_submissions_on_signature"

  create_table "calais_words", :force => true do |t|
    t.column "word", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "calais_words", ["permalink"], :name => "index_calais_words_on_permalink", :unique => true
  add_index "calais_words", ["word"], :name => "index_calais_words_on_word"

  create_table "categories", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "categories", ["permalink"], :name => "index_categories_on_permalink", :unique => true
  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "categories_natlib_metadatas", :id => false, :force => true do |t|
    t.column "category_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "categories_natlib_metadatas", ["category_id"], :name => "index_categories_natlib_metadatas_on_category_id"
  add_index "categories_natlib_metadatas", ["natlib_metadata_id"], :name => "index_categories_natlib_metadatas_on_natlib_metadata_id"

  create_table "centroids", :force => true do |t|
    t.column "latitude", :float
    t.column "longitude", :float
    t.column "extent_type", :string
    t.column "submission_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "centroids", ["submission_id"], :name => "centroids_submission_id_fk"

  create_table "collections", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "collections", ["permalink"], :name => "index_collections_on_permalink", :unique => true
  add_index "collections", ["name"], :name => "index_collections_on_name", :unique => true

  create_table "collections_natlib_metadatas", :id => false, :force => true do |t|
    t.column "collection_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "collections_natlib_metadatas", ["collection_id"], :name => "index_collections_natlib_metadatas_on_collection_id"
  add_index "collections_natlib_metadatas", ["natlib_metadata_id"], :name => "index_collections_natlib_metadatas_on_natlib_metadata_id"

  create_table "content_partners", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "content_partners", ["permalink"], :name => "index_content_partners_on_permalink", :unique => true
  add_index "content_partners", ["name"], :name => "index_content_partners_on_name", :unique => true

  create_table "content_partners_natlib_metadatas", :id => false, :force => true do |t|
    t.column "content_partner_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "content_partners_natlib_metadatas", ["content_partner_id"], :name => "index_content_partners_natlib_metadatas_on_content_partner_id"
  add_index "content_partners_natlib_metadatas", ["natlib_metadata_id"], :name => "index_content_partners_natlib_metadatas_on_natlib_metadata_id"

  create_table "contributors", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "contributors", ["permalink"], :name => "index_contributors_on_permalink", :unique => true
  add_index "contributors", ["name"], :name => "index_contributors_on_name", :unique => true

  create_table "contributors_natlib_metadatas", :id => false, :force => true do |t|
    t.column "contributor_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "contributors_natlib_metadatas", ["contributor_id"], :name => "index_contributors_natlib_metadatas_on_contributor_id"
  add_index "contributors_natlib_metadatas", ["natlib_metadata_id"], :name => "index_contributors_natlib_metadatas_on_natlib_metadata_id"

  create_table "countries", :force => true do |t|
    t.column "abbreviation", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "countries", ["abbreviation"], :name => "index_countries_on_abbreviation"

  create_table "country_names", :force => true do |t|
    t.column "country_id", :integer
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "country_names", ["country_id"], :name => "country_names_country_id_fk"

  create_table "coverages", :force => true do |t|
    t.column "name", :string
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "coverages", ["permalink"], :name => "index_coverages_on_permalink", :unique => true
  add_index "coverages", ["name"], :name => "index_coverages_on_name", :unique => true
  add_index "coverages", ["natlib_metadata_id"], :name => "coverages_natlib_metadata_id_fk"

  create_table "coverages_natlib_metadatas", :id => false, :force => true do |t|
    t.column "coverage_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "coverages_natlib_metadatas", ["coverage_id"], :name => "index_coverages_natlib_metadatas_on_coverage_id"
  add_index "coverages_natlib_metadatas", ["natlib_metadata_id"], :name => "index_coverages_natlib_metadatas_on_natlib_metadata_id"

  create_table "creators", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "creators", ["permalink"], :name => "index_creators_on_permalink", :unique => true
  add_index "creators", ["name"], :name => "index_creators_on_name", :unique => true

  create_table "creators_natlib_metadatas", :id => false, :force => true do |t|
    t.column "creator_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "creators_natlib_metadatas", ["creator_id"], :name => "index_creators_natlib_metadatas_on_creator_id"
  add_index "creators_natlib_metadatas", ["natlib_metadata_id"], :name => "index_creators_natlib_metadatas_on_natlib_metadata_id"

  create_table "downloaded_to_geoparse", :options=>'ENGINE=', :force => true do |t|
    t.column "natlib_id", :integer
    t.column "title", :text
  end

  create_table "extents", :force => true do |t|
    t.column "south", :float
    t.column "north", :float
    t.column "west", :float
    t.column "east", :float
    t.column "submission_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "extents", ["submission_id"], :name => "extents_submission_id_fk"

  create_table "facet_fields", :force => true do |t|
    t.column "name", :text
    t.column "parent_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "facet_fields", ["parent_id"], :name => "facet_fields_parent_id_fk"

  create_table "facet_fields_old", :force => true do |t|
    t.column "name", :string
    t.column "parent_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "filter_types", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "filter_types", ["name"], :name => "index_filter_types_on_name"

  create_table "filtered_phrases", :force => true do |t|
    t.column "phrase_id", :integer
    t.column "filter_type_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "filtered_phrases", ["phrase_id"], :name => "filtered_phrases_phrase_id_fk"
  add_index "filtered_phrases", ["filter_type_id"], :name => "filtered_phrases_filter_type_id_fk"

  create_table "filtered_phrases_submissions", :id => false, :force => true do |t|
    t.column "submission_id", :integer
    t.column "filtered_phrase_id", :integer
  end

  add_index "filtered_phrases_submissions", ["filtered_phrase_id"], :name => "index_filtered_phrases_submissions_on_filtered_phrase_id"
  add_index "filtered_phrases_submissions", ["submission_id"], :name => "index_filtered_phrases_submissions_on_submission_id"

  create_table "formats", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "formats", ["permalink"], :name => "index_formats_on_permalink", :unique => true
  add_index "formats", ["name"], :name => "index_formats_on_name", :unique => true

  create_table "formats_natlib_metadatas", :id => false, :force => true do |t|
    t.column "format_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "formats_natlib_metadatas", ["format_id"], :name => "index_formats_natlib_metadatas_on_format_id"
  add_index "formats_natlib_metadatas", ["natlib_metadata_id"], :name => "index_formats_natlib_metadatas_on_natlib_metadata_id"

  create_table "geo_sig", :options=>'ENGINE=', :force => true do |t|
    t.column "address", :string
    t.column "signature", :binary, :limit => 32
  end

  create_table "identifiers", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "identifiers", ["permalink"], :name => "index_identifiers_on_permalink", :unique => true
  add_index "identifiers", ["name"], :name => "index_identifiers_on_name", :unique => true

  create_table "identifiers_natlib_metadatas", :id => false, :force => true do |t|
    t.column "identifier_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "identifiers_natlib_metadatas", ["identifier_id"], :name => "index_identifiers_natlib_metadatas_on_identifier_id"
  add_index "identifiers_natlib_metadatas", ["natlib_metadata_id"], :name => "index_identifiers_natlib_metadatas_on_natlib_metadata_id"

  create_table "languages", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "languages", ["permalink"], :name => "index_languages_on_permalink", :unique => true
  add_index "languages", ["name"], :name => "index_languages_on_name", :unique => true

  create_table "languages_natlib_metadatas", :id => false, :force => true do |t|
    t.column "language_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "languages_natlib_metadatas", ["language_id"], :name => "index_languages_natlib_metadatas_on_language_id"
  add_index "languages_natlib_metadatas", ["natlib_metadata_id"], :name => "index_languages_natlib_metadatas_on_natlib_metadata_id"

  create_table "natlib_metadatas", :force => true do |t|
    t.column "description", :text
    t.column "title", :text
    t.column "landing_url", :text
    t.column "thumbnail_url", :text
    t.column "circa_date", :boolean
    t.column "natlib_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "pending", :boolean, :default => true
    t.column "permalink", :string
  end

  add_index "natlib_metadatas", ["permalink"], :name => "index_natlib_metadatas_on_permalink", :unique => true
  add_index "natlib_metadatas", ["natlib_id"], :name => "index_natlib_metadatas_on_natlib_id"
  add_index "natlib_metadatas", ["title"], :name => "natlib_title_index"
  add_index "natlib_metadatas", ["pending"], :name => "index_natlib_metadatas_on_pending"

  create_table "natlib_metadatas_old", :force => true do |t|
    t.column "creator", :string
    t.column "contributor", :string
    t.column "description", :text
    t.column "language", :string
    t.column "publisher", :string
    t.column "title", :text
    t.column "collection", :string
    t.column "landing_url", :string
    t.column "thumbnail_url", :string
    t.column "tipe_id", :integer
    t.column "content_partner", :string
    t.column "circa_date", :boolean
    t.column "natlib_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  create_table "natlib_metadatas_placenames", :id => false, :force => true do |t|
    t.column "placename_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "natlib_metadatas_placenames", ["placename_id"], :name => "index_natlib_metadatas_placenames_on_placename_id"
  add_index "natlib_metadatas_placenames", ["natlib_metadata_id"], :name => "index_natlib_metadatas_placenames_on_natlib_metadata_id"

  create_table "natlib_metadatas_publishers", :id => false, :force => true do |t|
    t.column "publisher_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "natlib_metadatas_publishers", ["publisher_id"], :name => "index_natlib_metadatas_publishers_on_publisher_id"
  add_index "natlib_metadatas_publishers", ["natlib_metadata_id"], :name => "index_natlib_metadatas_publishers_on_natlib_metadata_id"

  create_table "natlib_metadatas_relations", :id => false, :force => true do |t|
    t.column "relation_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "natlib_metadatas_relations", ["relation_id"], :name => "index_natlib_metadatas_relations_on_relation_id"
  add_index "natlib_metadatas_relations", ["natlib_metadata_id"], :name => "index_natlib_metadatas_relations_on_natlib_metadata_id"

  create_table "natlib_metadatas_rights", :id => false, :force => true do |t|
    t.column "right_id", :integer
    t.column "natlib_metadata_id", :integer
  end

  add_index "natlib_metadatas_rights", ["right_id"], :name => "index_natlib_metadatas_rights_on_right_id"
  add_index "natlib_metadatas_rights", ["natlib_metadata_id"], :name => "index_natlib_metadatas_rights_on_natlib_metadata_id"

  create_table "natlib_metadatas_subjects", :id => false, :force => true do |t|
    t.column "subject_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "natlib_metadatas_subjects", ["subject_id"], :name => "index_natlib_metadatas_subjects_on_subject_id"
  add_index "natlib_metadatas_subjects", ["natlib_metadata_id"], :name => "index_natlib_metadatas_subjects_on_natlib_metadata_id"

  create_table "natlib_metadatas_tipes", :id => false, :force => true do |t|
    t.column "tipe_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "natlib_metadatas_tipes", ["tipe_id"], :name => "index_natlib_metadatas_tipes_on_tipe_id"
  add_index "natlib_metadatas_tipes", ["natlib_metadata_id"], :name => "index_natlib_metadatas_tipes_on_natlib_metadata_id"

  create_table "phrase_frequencies", :force => true do |t|
    t.column "submission_id", :integer
    t.column "frequency", :integer
    t.column "phrase_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "phrase_frequencies", ["submission_id"], :name => "phrase_frequencies_submission_id_fk"
  add_index "phrase_frequencies", ["phrase_id"], :name => "phrase_frequencies_phrase_id_fk"

  create_table "phrases", :force => true do |t|
    t.column "words", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "phrases", ["permalink"], :name => "index_phrases_on_permalink", :unique => true
  add_index "phrases", ["words"], :name => "index_phrases_on_words"

  create_table "placenames", :force => true do |t|
    t.column "name", :string
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "placenames", ["permalink"], :name => "index_placenames_on_permalink", :unique => true
  add_index "placenames", ["name"], :name => "index_placenames_on_name", :unique => true
  add_index "placenames", ["natlib_metadata_id"], :name => "placenames_natlib_metadata_id_fk"

  create_table "publishers", :force => true do |t|
    t.column "name", :string
    t.column "permalink", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "publishers", ["permalink"], :name => "index_publishers_on_permalink", :unique => true
  add_index "publishers", ["name"], :name => "index_publishers_on_name", :unique => true

  create_table "record_dates", :force => true do |t|
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "record_dates", ["natlib_metadata_id"], :name => "record_dates_natlib_metadata_id_fk"

  create_table "relations", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "relations", ["permalink"], :name => "index_relations_on_permalink", :unique => true
  add_index "relations", ["name"], :name => "index_relations_on_name", :unique => true

  create_table "rights", :force => true do |t|
    t.column "name", :string
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "rights", ["permalink"], :name => "index_rights_on_permalink", :unique => true
  add_index "rights", ["name"], :name => "index_rights_on_name", :unique => true
  add_index "rights", ["natlib_metadata_id"], :name => "rights_natlib_metadata_id_fk"

  create_table "search_term_tags", :id => false, :options=>'ENGINE=', :force => true do |t|
    t.column "search_text", :string
    t.column "c", :integer, :limit => 8, :default => 0, :null => false
  end

  create_table "statistics", :force => true do |t|
    t.column "name", :string
    t.column "value", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "statistics", ["name"], :name => "index_statistics_on_name", :unique => true

  create_table "stop_words", :force => true do |t|
    t.column "word", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "stop_words", ["word"], :name => "index_stop_words_on_word"

  create_table "subjects", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "subjects", ["permalink"], :name => "index_subjects_on_permalink", :unique => true
  add_index "subjects", ["name"], :name => "index_subjects_on_name", :unique => true

  create_table "submission_place_count", :id => false, :options=>'ENGINE=', :force => true do |t|
    t.column "submission_id", :integer
    t.column "c", :integer, :limit => 8, :default => 0, :null => false
  end

  create_table "submissions", :force => true do |t|
    t.column "body_of_text", :text
    t.column "signature", :string
    t.column "extent_id", :integer
    t.column "centroid_id", :integer
    t.column "natlib_metadata_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "area", :float
  end

  add_index "submissions", ["area"], :name => "index_submissions_on_area"
  add_index "submissions", ["extent_id"], :name => "submissions_extent_id_fk"
  add_index "submissions", ["centroid_id"], :name => "submissions_centroid_id_fk"
  add_index "submissions", ["natlib_metadata_id"], :name => "submissions_natlib_metadata_id_fk"

  create_table "tipes", :force => true do |t|
    t.column "name", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "permalink", :string
  end

  add_index "tipes", ["name"], :name => "index_tipes_on_name"

  add_foreign_key "cached_geo_search_terms_cached_geo_searches", "cached_geo_search_terms", :name => "cached_geo_search_terms_cached_geo_searches_ibfk_2"
  add_foreign_key "cached_geo_search_terms_cached_geo_searches", "cached_geo_searches", :name => "cached_geo_search_terms_cached_geo_searches_ibfk_1"

  add_foreign_key "cached_geo_searches", "accuracies", :name => "cached_geo_searches_accuracy_id_fk"

  add_foreign_key "cached_geo_searches_cached_geo_search_terms", "cached_geo_search_terms", :name => "cached_geo_searches_cached_geo_search_terms_ibfk_2"
  add_foreign_key "cached_geo_searches_cached_geo_search_terms", "cached_geo_searches", :name => "cached_geo_searches_cached_geo_search_terms_ibfk_1"

  add_foreign_key "cached_geo_searches_submissions", "cached_geo_searches", :name => "cached_geo_searches_submissions_cached_geo_search_id_fk"
  add_foreign_key "cached_geo_searches_submissions", "submissions", :name => "cached_geo_searches_submissions_submission_id_fk"

  add_foreign_key "calais_entries", "calais_words", :name => "calais_entries_calais_child_word_id_fk", :column => "calais_child_word_id"
  add_foreign_key "calais_entries", "calais_words", :name => "calais_entries_calais_parent_word_id_fk", :column => "calais_parent_word_id"

  add_foreign_key "calais_entries_submissions", "calais_entries", :name => "calais_entries_submissions_calais_entry_id_fk"
  add_foreign_key "calais_entries_submissions", "submissions", :name => "calais_entries_submissions_submission_id_fk"

  add_foreign_key "categories_natlib_metadatas", "categories", :name => "categories_natlib_metadatas_category_id_fk"
  add_foreign_key "categories_natlib_metadatas", "natlib_metadatas", :name => "categories_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "centroids", "submissions", :name => "centroids_submission_id_fk"

  add_foreign_key "collections_natlib_metadatas", "collections", :name => "collections_natlib_metadatas_collection_id_fk"
  add_foreign_key "collections_natlib_metadatas", "natlib_metadatas", :name => "collections_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "content_partners_natlib_metadatas", "content_partners", :name => "content_partners_natlib_metadatas_content_partner_id_fk"
  add_foreign_key "content_partners_natlib_metadatas", "natlib_metadatas", :name => "content_partners_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "contributors_natlib_metadatas", "contributors", :name => "contributors_natlib_metadatas_contributor_id_fk"
  add_foreign_key "contributors_natlib_metadatas", "natlib_metadatas", :name => "contributors_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "country_names", "countries", :name => "country_names_country_id_fk"

  add_foreign_key "coverages", "natlib_metadatas", :name => "coverages_natlib_metadata_id_fk"

  add_foreign_key "coverages_natlib_metadatas", "coverages", :name => "coverages_natlib_metadatas_coverage_id_fk"
  add_foreign_key "coverages_natlib_metadatas", "natlib_metadatas", :name => "coverages_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "creators_natlib_metadatas", "creators", :name => "creators_natlib_metadatas_creator_id_fk"
  add_foreign_key "creators_natlib_metadatas", "natlib_metadatas", :name => "creators_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "extents", "submissions", :name => "extents_submission_id_fk"

  add_foreign_key "facet_fields", "facet_fields", :name => "facet_fields_parent_id_fk", :column => "parent_id"

  add_foreign_key "filtered_phrases", "filter_types", :name => "filtered_phrases_filter_type_id_fk"
  add_foreign_key "filtered_phrases", "phrases", :name => "filtered_phrases_phrase_id_fk"

  add_foreign_key "filtered_phrases_submissions", "filtered_phrases", :name => "filtered_phrases_submissions_filtered_phrase_id_fk"
  add_foreign_key "filtered_phrases_submissions", "submissions", :name => "filtered_phrases_submissions_submission_id_fk"

  add_foreign_key "formats_natlib_metadatas", "formats", :name => "formats_natlib_metadatas_format_id_fk"
  add_foreign_key "formats_natlib_metadatas", "natlib_metadatas", :name => "formats_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "identifiers_natlib_metadatas", "identifiers", :name => "identifiers_natlib_metadatas_identifier_id_fk"
  add_foreign_key "identifiers_natlib_metadatas", "natlib_metadatas", :name => "identifiers_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "languages_natlib_metadatas", "languages", :name => "languages_natlib_metadatas_language_id_fk"
  add_foreign_key "languages_natlib_metadatas", "natlib_metadatas", :name => "languages_natlib_metadatas_natlib_metadata_id_fk"

  add_foreign_key "natlib_metadatas_placenames", "natlib_metadatas", :name => "natlib_metadatas_placenames_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_placenames", "placenames", :name => "natlib_metadatas_placenames_placename_id_fk"

  add_foreign_key "natlib_metadatas_publishers", "natlib_metadatas", :name => "natlib_metadatas_publishers_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_publishers", "publishers", :name => "natlib_metadatas_publishers_publisher_id_fk"

  add_foreign_key "natlib_metadatas_relations", "natlib_metadatas", :name => "natlib_metadatas_relations_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_relations", "relations", :name => "natlib_metadatas_relations_relation_id_fk"

  add_foreign_key "natlib_metadatas_rights", "natlib_metadatas", :name => "natlib_metadatas_rights_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_rights", "rights", :name => "natlib_metadatas_rights_right_id_fk"

  add_foreign_key "natlib_metadatas_subjects", "natlib_metadatas", :name => "natlib_metadatas_subjects_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_subjects", "subjects", :name => "natlib_metadatas_subjects_subject_id_fk"

  add_foreign_key "natlib_metadatas_tipes", "natlib_metadatas", :name => "natlib_metadatas_tipes_natlib_metadata_id_fk"
  add_foreign_key "natlib_metadatas_tipes", "tipes", :name => "natlib_metadatas_tipes_tipe_id_fk"

  add_foreign_key "phrase_frequencies", "phrases", :name => "phrase_frequencies_phrase_id_fk"
  add_foreign_key "phrase_frequencies", "submissions", :name => "phrase_frequencies_submission_id_fk"

  add_foreign_key "placenames", "natlib_metadatas", :name => "placenames_natlib_metadata_id_fk"

  add_foreign_key "record_dates", "natlib_metadatas", :name => "record_dates_natlib_metadata_id_fk"

  add_foreign_key "rights", "natlib_metadatas", :name => "rights_natlib_metadata_id_fk"

  add_foreign_key "submissions", "centroids", :name => "submissions_centroid_id_fk"
  add_foreign_key "submissions", "extents", :name => "submissions_extent_id_fk"
  add_foreign_key "submissions", "natlib_metadatas", :name => "submissions_natlib_metadata_id_fk"

end
