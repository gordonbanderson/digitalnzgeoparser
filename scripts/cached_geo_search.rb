#!/usr/bin/env ../digitalnz/script/runner

require 'geography_helper'
include GeographyHelper


locations = parse_address("Wellington, New Zealand")
puts locations.to_yaml