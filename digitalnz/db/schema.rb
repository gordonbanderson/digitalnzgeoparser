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

ActiveRecord::Schema.define(:version => 20091207084748) do

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

  add_index "calais_words", ["word"], :name => "index_calais_words_on_word"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "centroids", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "extent_type"
    t.integer  "submission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "coverages", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "creators", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "facet_fields", :force => true do |t|
    t.text     "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "filtered_phrases_submissions", :id => false, :force => true do |t|
    t.integer "submission_id"
    t.integer "filtered_phrase_id"
  end

  create_table "formats", :force => true do |t|
    t.string   "name"
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

  create_table "natlib_metadatas_coverages", :force => true do |t|
    t.integer "coverage_id"
    t.integer "natlib_metadata_id"
  end

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

  create_table "natlib_metadatas_publishers", :id => false, :force => true do |t|
    t.integer  "publisher_id"
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

  create_table "phrases", :force => true do |t|
    t.string   "words"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "phrases", ["words"], :name => "index_phrases_on_words"

  create_table "placenames", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "record_dates", :force => true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relations", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "name"
    t.integer  "natlib_metadata_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

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

  create_table "tipes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tipes", ["name"], :name => "index_tipes_on_name"

end
