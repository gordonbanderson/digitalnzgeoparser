require 'geography_helper'
#require 'bigdecimal'

class Fixnz < ActiveRecord::Migration
  
  include GeographyHelper
=begin
=> "--- &id001 !ruby/object:CachedGeoSearch \nattributes: \n  permalink: \n  address: New Zealand\n  
atitude: \"-40.9005570000\"\n  created_at: 2010-01-24 08:43:49\n  country: New Zealand\n  admin_area: 
\n  metaphone1: \n  updated_at: 2010-02-08 14:07:15.761193 Z\n  metaphone2: \n  
signature: 6b6ab20850f27c9f10751f0f21fbedc2b98826f4fd99241cc28cf4f98b8500f5\n 
bbox_south: \n  accuracy_id: \"2\"\n  id: \"10\"\n  bbox_north: \n  bbox_west: \n  
locality: \n  dependent_locality: \n  longitude: \"174.8859710000\"\n  subadmin_area: \n  
bbox_east: \nattributes_cache: {}\n\nchanged_attributes: {}\n\nerrors: !ruby/object:ActiveRecord::Errors \n  base: *id001\n  errors: {}\n\nnew_record_before_save: false\n"


=end
  def self.up
    
    nz = CachedGeoSearch.find_by_address("New Zealand")
    
    #FIXME deal with the case when we are doing a clean install
    if !nz.blank?
      nz.bbox_south = BigDecimal('-47.4769319')
      nz.bbox_north = BigDecimal('-34.0428471')
      nz.bbox_west = BigDecimal('166.1901726')
      nz.bbox_east = BigDecimal('-176.1182306')
      nz.save!
      nz.spatialize
    end

    #spatialize
  end

  def self.down
  end
end
