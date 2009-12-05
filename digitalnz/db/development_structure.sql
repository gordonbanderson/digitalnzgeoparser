CREATE TABLE `accuracies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `google_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_accuracies_on_google_id` (`google_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `archive_searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `search_text` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `num_results_request` int(11) DEFAULT NULL,
  `page` int(11) DEFAULT NULL,
  `elapsed_time` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `cached_geo_search_terms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `search_term` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `failed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_country` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cached_geo_search_terms_on_search_term` (`search_term`)
) ENGINE=InnoDB AUTO_INCREMENT=464 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `cached_geo_searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `cached_geo_search_term_id` int(11) DEFAULT NULL,
  `admin_area` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `subadmin_area` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `dependent_locality` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `locality` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `accuracy_id` int(11) DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `bbox_west` float DEFAULT NULL,
  `bbox_east` float DEFAULT NULL,
  `bbox_north` float DEFAULT NULL,
  `bbox_south` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=994 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `cached_geo_searches_submissions` (
  `submission_id` int(11) DEFAULT NULL,
  `cached_geo_search_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `calais_child_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calais_word_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `calais_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calais_child_word_id` int(11) DEFAULT NULL,
  `calais_parent_word_id` int(11) DEFAULT NULL,
  `calais_submission_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `calais_parent_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `calais_word_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `calais_submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `signature` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_calais_submissions_on_signature` (`signature`)
) ENGINE=InnoDB AUTO_INCREMENT=342 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `calais_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_calais_words_on_word` (`word`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `centroids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `extent_type` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `submission_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `content_partners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abbreviation` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_countries_on_abbreviation` (`abbreviation`)
) ENGINE=InnoDB AUTO_INCREMENT=245 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `country_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `coverages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=366 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `extents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `south` float DEFAULT NULL,
  `north` float DEFAULT NULL,
  `west` float DEFAULT NULL,
  `east` float DEFAULT NULL,
  `submission_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=234 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `facet_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8_bin,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2621 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `facet_fields_old` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `filter_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_filter_types_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `filtered_phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phrase_id` int(11) DEFAULT NULL,
  `filter_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=288 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `filtered_phrases_submissions` (
  `submission_id` int(11) DEFAULT NULL,
  `filtered_phrase_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `formats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=258 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `identifiers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=515 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `natlib_metadatas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` text COLLATE utf8_bin,
  `contributor` text COLLATE utf8_bin,
  `description` text COLLATE utf8_bin,
  `language` text COLLATE utf8_bin,
  `publisher` text COLLATE utf8_bin,
  `title` text COLLATE utf8_bin,
  `collection` text COLLATE utf8_bin,
  `landing_url` text COLLATE utf8_bin,
  `thumbnail_url` text COLLATE utf8_bin,
  `tipe_id` int(11) DEFAULT NULL,
  `content_partner` text COLLATE utf8_bin,
  `circa_date` tinyint(1) DEFAULT NULL,
  `natlib_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `pending` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_natlib_metadatas_on_natlib_id` (`natlib_id`),
  KEY `natlib_title_index` (`title`(255)),
  KEY `natlib_content_partner_index` (`content_partner`(255))
) ENGINE=InnoDB AUTO_INCREMENT=4217 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `natlib_metadatas_coverages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `coverage_id` int(11) DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `natlib_metadatas_old` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `contributor` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `description` text COLLATE utf8_bin,
  `language` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `publisher` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `title` text COLLATE utf8_bin,
  `collection` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `landing_url` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `thumbnail_url` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `tipe_id` int(11) DEFAULT NULL,
  `content_partner` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `circa_date` tinyint(1) DEFAULT NULL,
  `natlib_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `natlib_metadatas_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `right_id` int(11) DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `phrase_frequencies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_id` int(11) DEFAULT NULL,
  `frequency` int(11) DEFAULT NULL,
  `phrase_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1564 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `words` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_phrases_on_words` (`words`)
) ENGINE=InnoDB AUTO_INCREMENT=604 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `placenames` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `record_dates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=170 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=224 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_bin NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `stop_words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stop_words_on_word` (`word`)
) ENGINE=InnoDB AUTO_INCREMENT=161 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `permalink` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=833 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `submissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `body_of_text` text COLLATE utf8_bin,
  `signature` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `extent_id` int(11) DEFAULT NULL,
  `centroid_id` int(11) DEFAULT NULL,
  `natlib_metadata_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `area` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_submissions_on_area` (`area`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

CREATE TABLE `tipes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tipes_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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