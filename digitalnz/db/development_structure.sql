--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accuracies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accuracies (
    id integer NOT NULL,
    name character varying(255),
    google_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: accuracies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accuracies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: accuracies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accuracies_id_seq OWNED BY accuracies.id;


--
-- Name: archive_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE archive_searches (
    id integer NOT NULL,
    search_text character varying(255),
    num_results_request integer,
    page integer,
    elapsed_time double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: archive_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE archive_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: archive_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE archive_searches_id_seq OWNED BY archive_searches.id;


--
-- Name: cached_geo_search_terms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cached_geo_search_terms (
    id integer NOT NULL,
    search_term character varying(255),
    failed boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_country boolean
);


--
-- Name: cached_geo_search_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cached_geo_search_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cached_geo_search_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cached_geo_search_terms_id_seq OWNED BY cached_geo_search_terms.id;


--
-- Name: cached_geo_searches; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cached_geo_searches (
    id integer NOT NULL,
    latitude double precision,
    longitude double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    cached_geo_search_term_id integer,
    admin_area character varying(255),
    subadmin_area character varying(255),
    dependent_locality character varying(255),
    locality character varying(255),
    accuracy_id integer,
    country character varying(255),
    address character varying(255),
    bbox_west double precision,
    bbox_east double precision,
    bbox_north double precision,
    bbox_south double precision
);


--
-- Name: cached_geo_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cached_geo_searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cached_geo_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cached_geo_searches_id_seq OWNED BY cached_geo_searches.id;


--
-- Name: cached_geo_searches_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cached_geo_searches_submissions (
    submission_id integer,
    cached_geo_search_id integer
);


--
-- Name: calais_child_words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calais_child_words (
    id integer NOT NULL,
    calais_word_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calais_child_words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calais_child_words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calais_child_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calais_child_words_id_seq OWNED BY calais_child_words.id;


--
-- Name: calais_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calais_entries (
    id integer NOT NULL,
    calais_child_word_id integer,
    calais_parent_word_id integer,
    calais_submission_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calais_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calais_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calais_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calais_entries_id_seq OWNED BY calais_entries.id;


--
-- Name: calais_parent_words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calais_parent_words (
    id integer NOT NULL,
    calais_word_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calais_parent_words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calais_parent_words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calais_parent_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calais_parent_words_id_seq OWNED BY calais_parent_words.id;


--
-- Name: calais_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calais_submissions (
    id integer NOT NULL,
    signature character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calais_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calais_submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calais_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calais_submissions_id_seq OWNED BY calais_submissions.id;


--
-- Name: calais_words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE calais_words (
    id integer NOT NULL,
    word character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: calais_words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE calais_words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: calais_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE calais_words_id_seq OWNED BY calais_words.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: centroids; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE centroids (
    id integer NOT NULL,
    latitude double precision,
    longitude double precision,
    extent_type character varying(255),
    submission_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: centroids_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE centroids_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: centroids_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE centroids_id_seq OWNED BY centroids.id;


--
-- Name: content_partners; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE content_partners (
    id integer NOT NULL,
    name character varying(255),
    permalink character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: content_partners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE content_partners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: content_partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE content_partners_id_seq OWNED BY content_partners.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    abbreviation character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: country_names; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE country_names (
    id integer NOT NULL,
    country_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: country_names_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE country_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: country_names_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE country_names_id_seq OWNED BY country_names.id;


--
-- Name: coverages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE coverages (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    permalink character varying(255)
);


--
-- Name: coverages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE coverages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: coverages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE coverages_id_seq OWNED BY coverages.id;


--
-- Name: extents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE extents (
    id integer NOT NULL,
    south double precision,
    north double precision,
    west double precision,
    east double precision,
    submission_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: extents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE extents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: extents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE extents_id_seq OWNED BY extents.id;


--
-- Name: facet_fields; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facet_fields (
    id integer NOT NULL,
    name text,
    parent_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: facet_fields_old; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE facet_fields_old (
    id integer NOT NULL,
    name character varying(255),
    parent_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: facet_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facet_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: facet_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facet_fields_id_seq OWNED BY facet_fields_old.id;


--
-- Name: facet_fields_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE facet_fields_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: facet_fields_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE facet_fields_id_seq1 OWNED BY facet_fields.id;


--
-- Name: filter_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filter_types (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: filter_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filter_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: filter_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE filter_types_id_seq OWNED BY filter_types.id;


--
-- Name: filtered_phrases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filtered_phrases (
    id integer NOT NULL,
    phrase_id integer,
    filter_type_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: filtered_phrases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE filtered_phrases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: filtered_phrases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE filtered_phrases_id_seq OWNED BY filtered_phrases.id;


--
-- Name: filtered_phrases_submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE filtered_phrases_submissions (
    submission_id integer,
    filtered_phrase_id integer
);


--
-- Name: formats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE formats (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE formats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE formats_id_seq OWNED BY formats.id;


--
-- Name: natlib_metadatas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE natlib_metadatas (
    id integer NOT NULL,
    creator text,
    contributor text,
    description text,
    language text,
    publisher text,
    title text,
    collection text,
    landing_url text,
    thumbnail_url text,
    tipe_id integer,
    content_partner text,
    circa_date boolean,
    natlib_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    pending boolean DEFAULT true
);


--
-- Name: submissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE submissions (
    id integer NOT NULL,
    body_of_text text,
    signature character varying(255),
    extent_id integer,
    centroid_id integer,
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    area double precision
);


--
-- Name: geoparsed_locations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW geoparsed_locations AS
    SELECT s.id AS submission_id, nm.natlib_id AS natlib_metadata_id, nm.title, cgss.cached_geo_search_id, cgst.search_term, cgs.accuracy_id, cgs.address FROM ((((submissions s JOIN natlib_metadatas nm ON ((s.natlib_metadata_id = nm.id))) JOIN cached_geo_searches_submissions cgss ON ((s.id = cgss.submission_id))) JOIN cached_geo_searches cgs ON ((cgss.cached_geo_search_id = cgs.id))) JOIN cached_geo_search_terms cgst ON ((cgs.cached_geo_search_term_id = cgst.id))) ORDER BY cgs.address, nm.title;


--
-- Name: geoparsed_records; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW geoparsed_records AS
    SELECT n.title, n.landing_url, n.thumbnail_url, n.description, n.content_partner, n.pending, n.natlib_id, s.area FROM (natlib_metadatas n JOIN submissions s ON ((s.natlib_metadata_id = n.id))) WHERE (n.pending = false);


--
-- Name: identifiers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE identifiers (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identifiers_id_seq OWNED BY identifiers.id;


--
-- Name: natlib_metadatas_coverages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE natlib_metadatas_coverages (
    id integer NOT NULL,
    coverage_id integer,
    natlib_metadata_id integer
);


--
-- Name: natlib_metadatas_coverages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE natlib_metadatas_coverages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: natlib_metadatas_coverages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE natlib_metadatas_coverages_id_seq OWNED BY natlib_metadatas_coverages.id;


--
-- Name: natlib_metadatas_old; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE natlib_metadatas_old (
    id integer NOT NULL,
    creator character varying(255),
    contributor character varying(255),
    description text,
    language character varying(255),
    publisher character varying(255),
    title text,
    collection character varying(255),
    landing_url character varying(255),
    thumbnail_url character varying(255),
    tipe_id integer,
    content_partner character varying(255),
    circa_date boolean,
    natlib_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: natlib_metadatas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE natlib_metadatas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: natlib_metadatas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE natlib_metadatas_id_seq OWNED BY natlib_metadatas_old.id;


--
-- Name: natlib_metadatas_id_seq1; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE natlib_metadatas_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: natlib_metadatas_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE natlib_metadatas_id_seq1 OWNED BY natlib_metadatas.id;


--
-- Name: phrase_frequencies; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phrase_frequencies (
    id integer NOT NULL,
    submission_id integer,
    frequency integer,
    phrase_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: phrase_frequencies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phrase_frequencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phrase_frequencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phrase_frequencies_id_seq OWNED BY phrase_frequencies.id;


--
-- Name: phrases; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE phrases (
    id integer NOT NULL,
    words character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: phrases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phrases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: phrases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phrases_id_seq OWNED BY phrases.id;


--
-- Name: placenames; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE placenames (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: placenames_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE placenames_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: placenames_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE placenames_id_seq OWNED BY placenames.id;


--
-- Name: record_dates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE record_dates (
    id integer NOT NULL,
    start_date date,
    end_date date,
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: record_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE record_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: record_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE record_dates_id_seq OWNED BY record_dates.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE relations (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE relations_id_seq OWNED BY relations.id;


--
-- Name: rights; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rights (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: rights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: rights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rights_id_seq OWNED BY rights.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: search_term_tags; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW search_term_tags AS
    SELECT archive_searches.search_text, count(archive_searches.search_text) AS c FROM archive_searches GROUP BY archive_searches.search_text ORDER BY count(archive_searches.search_text) DESC, archive_searches.search_text LIMIT 30;


--
-- Name: stop_words; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stop_words (
    id integer NOT NULL,
    word character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stop_words_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stop_words_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: stop_words_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stop_words_id_seq OWNED BY stop_words.id;


--
-- Name: subjects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subjects (
    id integer NOT NULL,
    name character varying(255),
    natlib_metadata_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subjects_id_seq OWNED BY subjects.id;


--
-- Name: submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE submissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE submissions_id_seq OWNED BY submissions.id;


--
-- Name: tipes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tipes (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: tipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: tipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tipes_id_seq OWNED BY tipes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE accuracies ALTER COLUMN id SET DEFAULT nextval('accuracies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE archive_searches ALTER COLUMN id SET DEFAULT nextval('archive_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE cached_geo_search_terms ALTER COLUMN id SET DEFAULT nextval('cached_geo_search_terms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE cached_geo_searches ALTER COLUMN id SET DEFAULT nextval('cached_geo_searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE calais_child_words ALTER COLUMN id SET DEFAULT nextval('calais_child_words_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE calais_entries ALTER COLUMN id SET DEFAULT nextval('calais_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE calais_parent_words ALTER COLUMN id SET DEFAULT nextval('calais_parent_words_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE calais_submissions ALTER COLUMN id SET DEFAULT nextval('calais_submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE calais_words ALTER COLUMN id SET DEFAULT nextval('calais_words_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE centroids ALTER COLUMN id SET DEFAULT nextval('centroids_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE content_partners ALTER COLUMN id SET DEFAULT nextval('content_partners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE country_names ALTER COLUMN id SET DEFAULT nextval('country_names_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE coverages ALTER COLUMN id SET DEFAULT nextval('coverages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE extents ALTER COLUMN id SET DEFAULT nextval('extents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE facet_fields ALTER COLUMN id SET DEFAULT nextval('facet_fields_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE facet_fields_old ALTER COLUMN id SET DEFAULT nextval('facet_fields_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE filter_types ALTER COLUMN id SET DEFAULT nextval('filter_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE filtered_phrases ALTER COLUMN id SET DEFAULT nextval('filtered_phrases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE formats ALTER COLUMN id SET DEFAULT nextval('formats_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE identifiers ALTER COLUMN id SET DEFAULT nextval('identifiers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE natlib_metadatas ALTER COLUMN id SET DEFAULT nextval('natlib_metadatas_id_seq1'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE natlib_metadatas_coverages ALTER COLUMN id SET DEFAULT nextval('natlib_metadatas_coverages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE natlib_metadatas_old ALTER COLUMN id SET DEFAULT nextval('natlib_metadatas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE phrase_frequencies ALTER COLUMN id SET DEFAULT nextval('phrase_frequencies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE phrases ALTER COLUMN id SET DEFAULT nextval('phrases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE placenames ALTER COLUMN id SET DEFAULT nextval('placenames_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE record_dates ALTER COLUMN id SET DEFAULT nextval('record_dates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE relations ALTER COLUMN id SET DEFAULT nextval('relations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE rights ALTER COLUMN id SET DEFAULT nextval('rights_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE stop_words ALTER COLUMN id SET DEFAULT nextval('stop_words_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE subjects ALTER COLUMN id SET DEFAULT nextval('subjects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE submissions ALTER COLUMN id SET DEFAULT nextval('submissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE tipes ALTER COLUMN id SET DEFAULT nextval('tipes_id_seq'::regclass);


--
-- Name: accuracies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accuracies
    ADD CONSTRAINT accuracies_pkey PRIMARY KEY (id);


--
-- Name: archive_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY archive_searches
    ADD CONSTRAINT archive_searches_pkey PRIMARY KEY (id);


--
-- Name: cached_geo_search_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cached_geo_search_terms
    ADD CONSTRAINT cached_geo_search_terms_pkey PRIMARY KEY (id);


--
-- Name: cached_geo_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cached_geo_searches
    ADD CONSTRAINT cached_geo_searches_pkey PRIMARY KEY (id);


--
-- Name: calais_child_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calais_child_words
    ADD CONSTRAINT calais_child_words_pkey PRIMARY KEY (id);


--
-- Name: calais_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calais_entries
    ADD CONSTRAINT calais_entries_pkey PRIMARY KEY (id);


--
-- Name: calais_parent_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calais_parent_words
    ADD CONSTRAINT calais_parent_words_pkey PRIMARY KEY (id);


--
-- Name: calais_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calais_submissions
    ADD CONSTRAINT calais_submissions_pkey PRIMARY KEY (id);


--
-- Name: calais_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY calais_words
    ADD CONSTRAINT calais_words_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: centroids_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY centroids
    ADD CONSTRAINT centroids_pkey PRIMARY KEY (id);


--
-- Name: content_partners_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY content_partners
    ADD CONSTRAINT content_partners_pkey PRIMARY KEY (id);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: country_names_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country_names
    ADD CONSTRAINT country_names_pkey PRIMARY KEY (id);


--
-- Name: coverages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY coverages
    ADD CONSTRAINT coverages_pkey PRIMARY KEY (id);


--
-- Name: extents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY extents
    ADD CONSTRAINT extents_pkey PRIMARY KEY (id);


--
-- Name: facet_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facet_fields_old
    ADD CONSTRAINT facet_fields_pkey PRIMARY KEY (id);


--
-- Name: facet_fields_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY facet_fields
    ADD CONSTRAINT facet_fields_pkey1 PRIMARY KEY (id);


--
-- Name: filter_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filter_types
    ADD CONSTRAINT filter_types_pkey PRIMARY KEY (id);


--
-- Name: filtered_phrases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY filtered_phrases
    ADD CONSTRAINT filtered_phrases_pkey PRIMARY KEY (id);


--
-- Name: formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);


--
-- Name: identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY identifiers
    ADD CONSTRAINT identifiers_pkey PRIMARY KEY (id);


--
-- Name: natlib_metadatas_coverages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY natlib_metadatas_coverages
    ADD CONSTRAINT natlib_metadatas_coverages_pkey PRIMARY KEY (id);


--
-- Name: natlib_metadatas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY natlib_metadatas_old
    ADD CONSTRAINT natlib_metadatas_pkey PRIMARY KEY (id);


--
-- Name: natlib_metadatas_pkey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY natlib_metadatas
    ADD CONSTRAINT natlib_metadatas_pkey1 PRIMARY KEY (id);


--
-- Name: phrase_frequencies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phrase_frequencies
    ADD CONSTRAINT phrase_frequencies_pkey PRIMARY KEY (id);


--
-- Name: phrases_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY phrases
    ADD CONSTRAINT phrases_pkey PRIMARY KEY (id);


--
-- Name: placenames_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY placenames
    ADD CONSTRAINT placenames_pkey PRIMARY KEY (id);


--
-- Name: record_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY record_dates
    ADD CONSTRAINT record_dates_pkey PRIMARY KEY (id);


--
-- Name: relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: rights_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rights
    ADD CONSTRAINT rights_pkey PRIMARY KEY (id);


--
-- Name: stop_words_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stop_words
    ADD CONSTRAINT stop_words_pkey PRIMARY KEY (id);


--
-- Name: subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY submissions
    ADD CONSTRAINT submissions_pkey PRIMARY KEY (id);


--
-- Name: tipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tipes
    ADD CONSTRAINT tipes_pkey PRIMARY KEY (id);


--
-- Name: index_accuracies_on_google_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accuracies_on_google_id ON accuracies USING btree (google_id);


--
-- Name: index_cached_geo_search_terms_on_search_term; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_cached_geo_search_terms_on_search_term ON cached_geo_search_terms USING btree (search_term);


--
-- Name: index_calais_submissions_on_signature; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calais_submissions_on_signature ON calais_submissions USING btree (signature);


--
-- Name: index_calais_words_on_word; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_calais_words_on_word ON calais_words USING btree (word);


--
-- Name: index_countries_on_abbreviation; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_on_abbreviation ON countries USING btree (abbreviation);


--
-- Name: index_facet_fields_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_facet_fields_on_name ON facet_fields USING btree (name);


--
-- Name: index_filter_types_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_filter_types_on_name ON filter_types USING btree (name);


--
-- Name: index_natlib_metadatas_on_content_partner; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_natlib_metadatas_on_content_partner ON natlib_metadatas USING btree (content_partner);


--
-- Name: index_natlib_metadatas_on_natlib_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_natlib_metadatas_on_natlib_id ON natlib_metadatas USING btree (natlib_id);


--
-- Name: index_natlib_metadatas_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_natlib_metadatas_on_title ON natlib_metadatas USING btree (title);


--
-- Name: index_phrases_on_words; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_phrases_on_words ON phrases USING btree (words);


--
-- Name: index_stop_words_on_word; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stop_words_on_word ON stop_words USING btree (word);


--
-- Name: index_submissions_on_area; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_submissions_on_area ON submissions USING btree (area);


--
-- Name: index_tipes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tipes_on_name ON tipes USING btree (name);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20090518094137');

INSERT INTO schema_migrations (version) VALUES ('20090527101630');

INSERT INTO schema_migrations (version) VALUES ('20090527103819');

INSERT INTO schema_migrations (version) VALUES ('20090527104841');

INSERT INTO schema_migrations (version) VALUES ('20090527110723');

INSERT INTO schema_migrations (version) VALUES ('20090527111103');

INSERT INTO schema_migrations (version) VALUES ('20090527111115');

INSERT INTO schema_migrations (version) VALUES ('20090527111124');

INSERT INTO schema_migrations (version) VALUES ('20090527111134');

INSERT INTO schema_migrations (version) VALUES ('20090527111144');

INSERT INTO schema_migrations (version) VALUES ('20090527111154');

INSERT INTO schema_migrations (version) VALUES ('20090528103648');

INSERT INTO schema_migrations (version) VALUES ('20090528103705');

INSERT INTO schema_migrations (version) VALUES ('20090531103712');

INSERT INTO schema_migrations (version) VALUES ('20090531105403');

INSERT INTO schema_migrations (version) VALUES ('20090531105859');

INSERT INTO schema_migrations (version) VALUES ('20090531110052');

INSERT INTO schema_migrations (version) VALUES ('20090531110207');

INSERT INTO schema_migrations (version) VALUES ('20090606070111');

INSERT INTO schema_migrations (version) VALUES ('20090606234639');

INSERT INTO schema_migrations (version) VALUES ('20090606235217');

INSERT INTO schema_migrations (version) VALUES ('20090607000638');

INSERT INTO schema_migrations (version) VALUES ('20090607001424');

INSERT INTO schema_migrations (version) VALUES ('20090613014221');

INSERT INTO schema_migrations (version) VALUES ('20090626064930');

INSERT INTO schema_migrations (version) VALUES ('20090626065714');

INSERT INTO schema_migrations (version) VALUES ('20090626070214');

INSERT INTO schema_migrations (version) VALUES ('20090626074557');

INSERT INTO schema_migrations (version) VALUES ('20090627063941');

INSERT INTO schema_migrations (version) VALUES ('20090627064023');

INSERT INTO schema_migrations (version) VALUES ('20090702090720');

INSERT INTO schema_migrations (version) VALUES ('20090708095955');

INSERT INTO schema_migrations (version) VALUES ('20090708101331');

INSERT INTO schema_migrations (version) VALUES ('20090709101301');

INSERT INTO schema_migrations (version) VALUES ('20090709101954');

INSERT INTO schema_migrations (version) VALUES ('20090711132738');

INSERT INTO schema_migrations (version) VALUES ('20090716095319');

INSERT INTO schema_migrations (version) VALUES ('20090716101144');

INSERT INTO schema_migrations (version) VALUES ('20091027103408');

INSERT INTO schema_migrations (version) VALUES ('20091102051220');

INSERT INTO schema_migrations (version) VALUES ('20091103030941');

INSERT INTO schema_migrations (version) VALUES ('20091103033427');

INSERT INTO schema_migrations (version) VALUES ('20091103034737');

INSERT INTO schema_migrations (version) VALUES ('20091120044902');

INSERT INTO schema_migrations (version) VALUES ('20091120062342');

INSERT INTO schema_migrations (version) VALUES ('20091120082300');

INSERT INTO schema_migrations (version) VALUES ('20091122045249');

INSERT INTO schema_migrations (version) VALUES ('20091123125906');

INSERT INTO schema_migrations (version) VALUES ('20091123130322');

INSERT INTO schema_migrations (version) VALUES ('20091128024637');

INSERT INTO schema_migrations (version) VALUES ('20091128030900');

INSERT INTO schema_migrations (version) VALUES ('20091128035849');

INSERT INTO schema_migrations (version) VALUES ('20091128055157');

INSERT INTO schema_migrations (version) VALUES ('20091201141636');