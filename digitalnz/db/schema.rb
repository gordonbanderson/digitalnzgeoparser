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

ActiveRecord::Schema.define(:version => 20091208152031) do

  create_table "accuracies", :force => true do |t|
    t.string   "name"
    t.integer  "google_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accuracies", ["google_id"], :name => "index_accuracies_on_google_id"

  create_table "archive_searches", :force => true do |t|
    t.string   "search_text"
    t.integer  "num_results_request"
    t.integer  "page"
    t.float    "elapsed_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cached_geo_search_terms", :force => true do |t|
    t.string   "search_term"
    t.boolean  "failed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_country"
  end

  add_index "cached_geo_search_terms", ["search_term"], :name => "index_cached_geo_search_terms_on_search_term"

  create_table "cached_geo_searches", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_geo_search_term_id"
    t.string   "admin_area"
    t.string   "subadmin_area"
    t.string   "dependent_locality"
    t.string   "locality"
    t.integer  "accuracy_id"
    t.string   "country"
    t.string   "address"
    t.string   "permalink"
    t.float    "bbox_west"
    t.float    "bbox_east"
    t.float    "bbox_north"
    t.float    "bbox_south"
  end

  add_index "cached_geo_searches", ["accuracy_id"], :name => "cached_geo_searches_accuracy_id_fk"
  add_index "cached_geo_searches", ["cached_geo_search_term_id"], :name => "cached_geo_searches_cached_geo_search_term_id_fk"
  add_index "cached_geo_searches", ["permalink"], :name => "index_cached_geo_searches_on_permalink", :unique => true

  create_table "cached_geo_searches_submissions", :id => false, :force => true do |t|
    t.integer "submission_id"
    t.integer "cached_geo_search_id"
  end

  create_table "calais_entries", :force => true do |t|
    t.integer  "calais_child_word_id"
    t.integer  "calais_parent_word_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calais_entries", ["calais_child_word_id"], :name => "calais_entries_calais_child_word_id_fk"
  add_index "calais_entries", ["calais_parent_word_id"], :name => "calais_entries_calais_parent_word_id_fk"

  create_table "calais_entries_submissions", :id => false, :force => true do |t|
    t.integer  "calais_entry_id"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calais_submissions", :force => true do |t|
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calais_submissions", ["signature"], :name => "index_calais_submissions_on_signature"

  create_table "calais_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "calais_words", ["permalink"], :name => "index_calais_words_on_permalink", :unique => true
  add_index "calais_words", ["word"], :name => "index_calais_words_on_word"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true
  add_index "categories", ["permalink"], :name => "index_categories_on_permalink", :unique => true

  create_table "categories_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "category_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "centroids", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "extent_type"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "centroids", ["submission_id"], :name => "centroids_submission_id_fk"

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["name"], :name => "index_collections_on_name", :unique => true
  add_index "collections", ["permalink"], :name => "index_collections_on_permalink", :unique => true

  create_table "collections_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "collection_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_partners", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_partners", ["name"], :name => "index_content_partners_on_name", :unique => true
  add_index "content_partners", ["permalink"], :name => "index_content_partners_on_permalink", :unique => true

  create_table "content_partners_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "content_partner_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributors", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributors", ["name"], :name => "index_contributors_on_name", :unique => true
  add_index "contributors", ["permalink"], :name => "index_contributors_on_permalink", :unique => true

  create_table "contributors_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "contributor_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["abbreviation"], :name => "index_countries_on_abbreviation"

  create_table "country_names", :force => true do |t|
    t.integer  "country_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "country_names", ["country_id"], :name => "country_names_country_id_fk"

  create_table "coverages", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "coverages", ["name"], :name => "index_coverages_on_name", :unique => true
  add_index "coverages", ["natlib_metadata_id"], :name => "coverages_natlib_metadata_id_fk"
  add_index "coverages", ["permalink"], :name => "index_coverages_on_permalink", :unique => true

  create_table "coverages_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "coverage_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "creators", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "creators", ["name"], :name => "index_creators_on_name", :unique => true
  add_index "creators", ["permalink"], :name => "index_creators_on_permalink", :unique => true

  create_table "creators_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "creator_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extents", :force => true do |t|
    t.float    "south"
    t.float    "north"
    t.float    "west"
    t.float    "east"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extents", ["submission_id"], :name => "extents_submission_id_fk"

  create_table "facet_fields", :force => true do |t|
    t.text     "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facet_fields", ["parent_id"], :name => "facet_fields_parent_id_fk"

  create_table "facet_fields_old", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filter_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "filter_types", ["name"], :name => "index_filter_types_on_name"

  create_table "filtered_phrases", :force => true do |t|
    t.integer  "phrase_id"
    t.integer  "filter_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "filtered_phrases", ["filter_type_id"], :name => "filtered_phrases_filter_type_id_fk"
  add_index "filtered_phrases", ["phrase_id"], :name => "filtered_phrases_phrase_id_fk"

  create_table "filtered_phrases_submissions", :id => false, :force => true do |t|
    t.integer "submission_id"
    t.integer "filtered_phrase_id"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "formats", ["name"], :name => "index_formats_on_name", :unique => true
  add_index "formats", ["permalink"], :name => "index_formats_on_permalink", :unique => true

  create_table "formats_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "format_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geoparsed_locations", :id => false, :force => true do |t|
    t.integer "submission_id",        :default => 0, :null => false
    t.integer "natlib_metadata_id"
    t.text    "title"
    t.integer "cached_geo_search_id"
    t.string  "search_term"
    t.integer "accuracy_id"
    t.string  "address"
  end

  create_table "geoparsed_records", :id => false, :force => true do |t|
    t.text    "title"
    t.text    "landing_url"
    t.text    "thumbnail_url"
    t.text    "description"
    t.boolean "pending",       :default => true
    t.integer "natlib_id"
    t.float   "area"
  end

  create_table "identifiers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "identifiers", ["name"], :name => "index_identifiers_on_name", :unique => true
  add_index "identifiers", ["permalink"], :name => "index_identifiers_on_permalink", :unique => true

  create_table "identifiers_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "identifier_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "languages", ["name"], :name => "index_languages_on_name", :unique => true
  add_index "languages", ["permalink"], :name => "index_languages_on_permalink", :unique => true

  create_table "languages_natlib_metadatas", :id => false, :force => true do |t|
    t.integer  "language_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas", :force => true do |t|
    t.text     "description"
    t.text     "title"
    t.text     "landing_url"
    t.text     "thumbnail_url"
    t.boolean  "circa_date"
    t.integer  "natlib_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending",       :default => true
  end

  add_index "natlib_metadatas", ["natlib_id"], :name => "index_natlib_metadatas_on_natlib_id"
  add_index "natlib_metadatas", ["title"], :name => "natlib_title_index"

  create_table "natlib_metadatas_old", :force => true do |t|
    t.string   "creator"
    t.string   "contributor"
    t.text     "description"
    t.string   "language"
    t.string   "publisher"
    t.text     "title"
    t.string   "collection"
    t.string   "landing_url"
    t.string   "thumbnail_url"
    t.integer  "tipe_id"
    t.string   "content_partner"
    t.boolean  "circa_date"
    t.integer  "natlib_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas_placenames", :id => false, :force => true do |t|
    t.integer  "placename_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas_publishers", :id => false, :force => true do |t|
    t.integer  "publisher_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas_relations", :id => false, :force => true do |t|
    t.integer  "relation_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas_rights", :force => true do |t|
    t.integer "right_id"
    t.integer "natlib_metadata_id"
  end

  create_table "natlib_metadatas_subjects", :id => false, :force => true do |t|
    t.integer  "subject_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "natlib_metadatas_tipes", :id => false, :force => true do |t|
    t.integer  "tipe_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phrase_frequencies", :force => true do |t|
    t.integer  "submission_id"
    t.integer  "frequency"
    t.integer  "phrase_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phrase_frequencies", ["phrase_id"], :name => "phrase_frequencies_phrase_id_fk"
  add_index "phrase_frequencies", ["submission_id"], :name => "phrase_frequencies_submission_id_fk"

  create_table "phrases", :force => true do |t|
    t.string   "words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "phrases", ["permalink"], :name => "index_phrases_on_permalink", :unique => true
  add_index "phrases", ["words"], :name => "index_phrases_on_words"

  create_table "placenames", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "placenames", ["name"], :name => "index_placenames_on_name", :unique => true
  add_index "placenames", ["natlib_metadata_id"], :name => "placenames_natlib_metadata_id_fk"
  add_index "placenames", ["permalink"], :name => "index_placenames_on_permalink", :unique => true

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "publishers", ["name"], :name => "index_publishers_on_name", :unique => true
  add_index "publishers", ["permalink"], :name => "index_publishers_on_permalink", :unique => true

  create_table "record_dates", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "record_dates", ["natlib_metadata_id"], :name => "record_dates_natlib_metadata_id_fk"

  create_table "relations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "relations", ["name"], :name => "index_relations_on_name", :unique => true
  add_index "relations", ["permalink"], :name => "index_relations_on_permalink", :unique => true

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "rights", ["name"], :name => "index_rights_on_name", :unique => true
  add_index "rights", ["natlib_metadata_id"], :name => "rights_natlib_metadata_id_fk"
  add_index "rights", ["permalink"], :name => "index_rights_on_permalink", :unique => true

  create_table "search_term_tags", :id => false, :force => true do |t|
    t.string  "search_text"
    t.integer "c",           :limit => 8, :default => 0, :null => false
  end

  create_table "stop_words", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stop_words", ["word"], :name => "index_stop_words_on_word"

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "subjects", ["name"], :name => "index_subjects_on_name", :unique => true
  add_index "subjects", ["permalink"], :name => "index_subjects_on_permalink", :unique => true

  create_table "submissions", :force => true do |t|
    t.text     "body_of_text"
    t.string   "signature"
    t.integer  "extent_id"
    t.integer  "centroid_id"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "area"
  end

  add_index "submissions", ["area"], :name => "index_submissions_on_area"
  add_index "submissions", ["centroid_id"], :name => "submissions_centroid_id_fk"
  add_index "submissions", ["extent_id"], :name => "submissions_extent_id_fk"
  add_index "submissions", ["natlib_metadata_id"], :name => "submissions_natlib_metadata_id_fk"

  create_table "tipes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipes", ["name"], :name => "index_tipes_on_name"

  add_foreign_key "cached_geo_searches", "accuracies", :name => "cached_geo_searches_accuracy_id_fk"
  add_foreign_key "cached_geo_searches", "cached_geo_search_terms", :name => "cached_geo_searches_cached_geo_search_term_id_fk"

  add_foreign_key "calais_entries", "calais_words", :name => "calais_entries_calais_child_word_id_fk", :column => "calais_child_word_id"
  add_foreign_key "calais_entries", "calais_words", :name => "calais_entries_calais_parent_word_id_fk", :column => "calais_parent_word_id"

  add_foreign_key "centroids", "submissions", :name => "centroids_submission_id_fk"

  add_foreign_key "country_names", "countries", :name => "country_names_country_id_fk"

  add_foreign_key "coverages", "natlib_metadatas", :name => "coverages_natlib_metadata_id_fk"

  add_foreign_key "extents", "submissions", :name => "extents_submission_id_fk"

  add_foreign_key "facet_fields", "facet_fields", :name => "facet_fields_parent_id_fk", :column => "parent_id"

  add_foreign_key "filtered_phrases", "filter_types", :name => "filtered_phrases_filter_type_id_fk"
  add_foreign_key "filtered_phrases", "phrases", :name => "filtered_phrases_phrase_id_fk"

  add_foreign_key "phrase_frequencies", "phrases", :name => "phrase_frequencies_phrase_id_fk"
  add_foreign_key "phrase_frequencies", "submissions", :name => "phrase_frequencies_submission_id_fk"

  add_foreign_key "placenames", "natlib_metadatas", :name => "placenames_natlib_metadata_id_fk"

  add_foreign_key "record_dates", "natlib_metadatas", :name => "record_dates_natlib_metadata_id_fk"

  add_foreign_key "rights", "natlib_metadatas", :name => "rights_natlib_metadata_id_fk"

  add_foreign_key "submissions", "centroids", :name => "submissions_centroid_id_fk"
  add_foreign_key "submissions", "extents", :name => "submissions_extent_id_fk"
  add_foreign_key "submissions", "natlib_metadatas", :name => "submissions_natlib_metadata_id_fk"

end
