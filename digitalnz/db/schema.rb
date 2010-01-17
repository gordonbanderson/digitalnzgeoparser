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

  add_index "cached_geo_search_terms_cached_geo_searches", ["cached_geo_search_id"], :name => "index_cgs_join21_id"
  add_index "cached_geo_search_terms_cached_geo_searches", ["cached_geo_search_term_id"], :name => "index_cgs_join22_id"

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

