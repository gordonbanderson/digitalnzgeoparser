#!/usr/bin/env ../digitalnz/script/runner

require 'rubygems'
require 'faster_csv'

require 'calais_helper'
require 'google_geocode_json_client'
require 'memcache'


include CalaisHelper
include GoogleGeocodeHelper


def cgs_details(cgs)
  result = "CGS:#{cgs.address}"
  result << "\tW:#{cgs.bbox_west} -> E:#{cgs.bbox_east}"
  result << "\tS:#{cgs.bbox_south} -> N:#{cgs.bbox_north}"
  result
end

n = NatlibMetadata.find_by_natlib_id(ARGV[0])
puts n.title

cgs = n.submission.cached_geo_searches
cgs.uniq!
puts "CGS:#{cgs}"

for c in cgs
  puts "#{c.id} - #{c.address} - #{c.spatial_cached_geo_search.bounding_box}"
end


=begin
/Users/gordon/work/git/geo/digitalnz
Start with an existing table called geometry, add a spatial column and index it:
ALTER TABLE geometry ADD coord POINT NOT NULL;
CREATE SPATIAL INDEX coord ON geometry (coord);
Insert some data; think in terms of POINT(X Y) or POINT(lat lon):
INSERT INTO geometry (coord) VALUES( GeomFromText( 'POINT(40 -100)' ));
INSERT INTO geometry (coord) VALUES( GeomFromText( 'POINT(1 1)' ));
Get those X,Y coordinates back from the table:
SELECT X(coord), Y(coord) FROM geometry
Get points within a bounding rectangle:
SELECT MBRContains(
	GeomFromText( 'POLYGON((0 0,0 3,3 3,3 0,0 0))' ),
	coord
)
FROM geometry


select MBROverlaps(GeomFromText('POLYGON((174.7602096 -41.2948638,174.7602096 -41.2780951,174.7922244 -41.2780951,174.7922244 -41.2948638,174.7602096 -41.2948638))'), GeomFromText('POLYGON((174.7690916 -41.3055734,174.7690916 -41.2888075,174.8011064 -41.2888075,174.8011064 -41.3055734,174.7690916 -41.3055734))'));
select MBROverlaps(
GeomFromText('POLYGON((174.7690916 -41.3055734,174.7690916 -41.2888075,174.8011064 -41.2888075,174.8011064 -41.3055734,174.7690916 -41.3055734))'),
GeomFromText('POLYGON((174.7602096 -41.2948638,174.7602096 -41.2780951,174.7922244 -41.2780951,174.7922244 -41.2948638,174.7602096 -41.2948638))')

select s.id, cached_geo_search_id, address
from spatial_cached_geo_searches s
inner join cached_geo_searches cgs
on (cgs.id = s.cached_geo_search_id)
where MBRContains(
GeomFromText('POLYGON((174.7602096 -41.2948638,174.7602096 -41.2780951,174.7922244 -41.2780951,174.7922244 -41.2948638,174.7602096 -41.2948638))'),
coordinates) = 1
;


mysql> select x(coordinates), y(coordinates) from spatial_cached_geo_searches limit 10;
+----------------+----------------+
| x(coordinates) | y(coordinates) |
+----------------+----------------+
|     174.803641 |     -41.292789 |
|     174.802876 |     -41.291939 |
|     17.8942883 |     60.2278639 |
|     174.794851 |     -41.291181 |
|      174.80458 |     -41.285608 |
|     174.801172 |     -41.291016 |
|     117.042277 |     -33.659042 |
|     174.776217 |      -41.28648 |
|      8.7829723 |     45.6065827 |
|     174.885971 |     -40.900557 |
+----------------+----------------+

select MBRContains(
	GeomFromText('POLYGON((174 -41, 175 -41, 175 -40.8, 174 -40.8, 174 -41))' ),
	coordinates
)
FROM spatial_cached_geo_searches
limit 100;
  
=end


#1473616 is a good example, lots of US hits but not containment
#1512897 also, 1525780, 1467153

cgs = n.submission.cached_geo_searches
cgs_spatial_ids = cgs.map{|c| c.spatial_cached_geo_search.id}

puts "SPATIAL CGS KEYS:#{cgs_spatial_ids.map{|s| s.id}}"

# This will map parent MBR to contained MBR in a parent child relationship
contains_hash = {}


for c in cgs
  spatial_ids_less_self = cgs_spatial_ids.clone
  spatial_ids_less_self.delete(c.spatial_cached_geo_search.id)
  
  contains_hash[c] = []
  
  
  if spatial_ids_less_self.blank?
    #Only one item so no point doing the query
  else
    
  
    #Check for east/west split
    #FIXME - check north/south also
    west = c.bbox_west
    east = c.bbox_east
    geoms = [c.spatial_cached_geo_search.bounding_box.as_wkt]
  
    if east < west
      puts "DATE LINE STRADDLING!"
      puts "E:#{east}  W:#{west}"
      puts geoms
    
    end
  
    geom = geoms[0]
  
    puts "\n\nLOOKING FOR ITEMS INSIDE C(#{c.id}) - #{c.address} - #{geom}"
  
    puts geom
    sql = "
    select s.*
    from spatial_cached_geo_searches s
    inner join cached_geo_searches cgs
    on (cgs.id = s.cached_geo_search_id)
    where
    s.id in (#{spatial_ids_less_self.join(',')})
    and MBRContains(
    GeomFromText('#{geom}'),
    bounding_box) = 1
    "
  
  
    inside_spatial_ids = SpatialCachedGeoSearch.find_by_sql(sql)
  
    #inside_spatial_ids = ActiveRecord::Base.connection().execute(sql)
    puts inside_spatial_ids.to_yaml
  
  
  
    for i in inside_spatial_ids
      #puts i.class
      puts "\tINSIDE:#{i.cached_geo_search.address}"
      contains_hash[c] << i
    end
    puts
  end
end

leafs = []
for key in contains_hash.keys

  children = contains_hash[key]
  if children.length > 0
    puts "KEY:#{cgs_details(key)}"
    puts "\tCONTAINS:"
    for child in contains_hash[key]
      puts "\t\t#{child.cached_geo_search.address}"
    end
  else
    leafs << key
  end

end


for leaf in leafs
  puts "LEAF:#{leaf.address}"
end


tree = {}
keys = contains_hash.keys


#Work out all the descendents of a given node
def descendents(contains_hash, parent_node)
  return descendent_recurse(contains_hash, parent_node, [])
end


def descendent_recurse(contains_hash, parent_node, result)
  for descendent in contains_hash[parent_node].map{|s| s.cached_geo_search}
    result << descendent
    result << descendent_recurse(contains_hash, descendent, result) if !contains_hash[descendent].blank?
  end
end



for key in keys
  puts "DESCENDENTS OF:#{key.address}"
  puts descendents(contains_hash, key).map{|c|c.address}
  puts
end

puts "\n\n+++++++++++++++++++++++++++++\n\n"

hierarchy_each_node = {}

#Now to work through the containment to form a tree
#Pass one - identify children who also have children


for key in keys
  all_child_descendents = []
  children = contains_hash[key]
  bb = BoundingBoxTree::new
  bb.cached_geo_search_id = key.id
  
  puts "\n\n++++\n\nCHECKING KEY:#{key.address}"
  key_direct_children = []
  possible_direct_children = []

  for child in children.map{|s|s.cached_geo_search}
    descendents = []
    for kdc in key_direct_children
       descendents << descendents(contains_hash, kdc)
      
    end
    descendents.flatten!
    all_child_descendents << descendents
    all_child_descendents.flatten!

    puts "\t\t\t\tChecking child:#{child.address}"
    if !contains_hash[child].blank? #ie not a leaf, ie grandchildren exist
      key_direct_children << child
      puts "\t\t\t\t ADDING PARENTAL #{child.address}"
      #Now remove any descendants of this node
      #FIXME recurse
      hierarchy_each_node[child.address] = contains_hash[child].map{|c| c.cached_geo_search.address}
 #     for grandchild in contains_hash[child]
 #       puts "DEAL WITH #{grandchild.cached_geo_search.address}"
 #     end
      

      
      puts "\t\t\t\t\tDESCENDENTS BLAH:#{descendents.map{|c| c.address}.join(' | ')}"


      orphans = []
      #Now add any fellow orphans, see 1425448 for an example, but only at the children level
      for child2 in children.map{|s|s.cached_geo_search}
        puts "\t\t\t#CHECKING FILTER: #{child2.address}"
        if contains_hash[child2].blank?
          puts "\t\t\t\tMAYBE ADDING ORPHAN AT SAME LEVEL OR DESC:#{child2.address}"
          if descendents.include? child2
            puts "\t\t\t\t\tIGNORING, IS GRANDCHILD OR MORE"
          else
            puts "\t\t\t\t\tADDED"
            orphans << child2
            
          end
        end
      end
      puts "ORPHANS:"+orphans.map{|o| o.address}.join(' | ')


    #A leaf may be a direct descendent, in which case we require to keep it for further analysis
    
    else
        possible_direct_children << child
    end
  
    puts "POSSIBLE DIRECT CHILDREN: #{possible_direct_children.map{|o| o.address}.join(' | ')}"
    puts "all_child_descendents: #{all_child_descendents.map{|o| o.address}.join(' | ')}"
    child_orphans = []
    for gc in possible_direct_children
      puts gc.class
      child_orphans << gc if !all_child_descendents.include?(gc)
    end
    
    child_orphans.uniq!
    
    puts "DIRECT CHILD ORPHANS: #{child_orphans.map{|o| o.address}.join(' | ')}"
    key_direct_children << child_orphans.flatten
    key_direct_children.flatten!.uniq!

    puts "+++++ /CHECKING CHILD +++++"
    
  
  end
  

  
  hierarchy_each_node[key.address] = key_direct_children.map{|k| k.address} if !key_direct_children.blank?
  
  puts "--\n\n"
  
end


puts "HHHHHHHHHHHHHHH"
puts hierarchy_each_node.to_yaml
puts "/HHHHHHHHHHHHHHH"


puts n.submission.body_of_text
