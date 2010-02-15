module BoundingBoxHelper
  
  #Work out the 'best' bounding boxes for this record
  #@param natlib_metadata Natlib metadata record
  def probable_location(natlib_metadata)
    depths = {}
    for bbox in natlib_metadata.submission.bounding_box_trees
      depth = depth(bbox)
      depths[bbox] = depth
    end

    max_depth = depths.values.max
    max_depth = - 1 if max_depth.blank?

    result = []
    for key in depths.keys
      depth = depths[key]
      result << key if depth == max_depth
    end

    {
      :max_depth => max_depth,
      :bounding_boxes => result
    }
  end


  def print_hierarchy(bbox_tree)
    result = ""
    nodes = [bbox_tree]
    current_node = bbox_tree
    while !current_node.parent.blank?
      current_node = current_node.parent
      nodes << current_node
    end
    nodes.map{|n| n.cached_geo_search.address }.join('  <  ')
  end
  
  
  
  #Calculate the MBR tree using the following heuristics
  # * MBR is contained inside parent MBR
  # * For MBRs at the same level check for an intersection and if one is more accurate than the other, make
  #   the more accurate one the child
  # * If still no results, use 'near' instead of contains or intersects
  def calculate_mbr_tree
    

    #1473616 is a good example, lots of US hits but not containment
    #1512897 also, 1525780, 1467153

    #Good example for intersection testing - 1512897

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
        all_child_descendents.uniq!

        puts "\t\t\t\tChecking child:#{child.address}"
        if !contains_hash[child].blank? #ie not a leaf, ie grandchildren exist
          key_direct_children << child
          puts "\t\t\t\t ADDING PARENTAL #{child.address}"
          #Now remove any descendants of this node
          #FIXME recurse
          hierarchy_each_node[child] = contains_hash[child].map{|c| c.cached_geo_search}
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
          child_orphans << gc if !all_child_descendents.include?(gc)
        end

        child_orphans.uniq!

        puts "DIRECT CHILD ORPHANS: #{child_orphans.map{|o| o.address}.join(' | ')}"
        key_direct_children << child_orphans.flatten
        key_direct_children.flatten!.uniq!

        puts "+++++ /CHECKING CHILD +++++"


      end



      hierarchy_each_node[key] = key_direct_children if !key_direct_children.blank?
      puts "T2 "
      hierarchy_each_node.keys.map{|k| puts k.class}

      puts key.class
      puts "--\n\n"

    end


    puts "HHHHHHHHHHHHHHH"
    puts "T3 "
    hierarchy_each_node.keys.map{|k| puts k.address}

    puts "\n\nHIERARCHY\n\n"
    for key in hierarchy_each_node.keys
      puts "PARENT:#{key.address}"
      for child in hierarchy_each_node[key]
        puts "\tCHILD:#{child.address}"
      end
    end
    puts "\n\n/++++++++\n\n\n\n"

    #Store a list of those items that have children to store
    parents_with_children = []

    for key in hierarchy_each_node.keys
      puts "PARENT:"+key.id.to_s+' - '+key.address

      BoundingBoxTree.find(:all, :conditions => ["submission_id=?", n.submission]).map{|b|b.destroy}


      bb_parent = BoundingBoxTree::new
      bb_parent.cached_geo_search = key
      bb_parent.submission = n.submission
      bb_parent.save!


      for child in hierarchy_each_node[key]
        puts "\tCHILD: #{child.id} - #{child.address}"
        bb_child = BoundingBoxTree::new
        bb_child.cached_geo_search = child
        bb_child.submission = n.submission
        bb_child.parent = bb_parent
        bb_child.save!

        if !hierarchy_each_node[child].blank?
          puts "**** #{child.address} has more children"
          parents_with_children << bb_child
        end
      end
    end
    puts "/HHHHHHHHHHHHHHH"

    #Make into a tree
    for i in 1..1000
      puts "LOOP:#{i}"

      new_parents_with_children = []
      for parent_bbox in parents_with_children
        cgs = parent_bbox.cached_geo_search
        for child in hierarchy_each_node[cgs]
          puts "\tCHILD: #{child.id} - #{child.address}"
          bb_child = BoundingBoxTree::new
          bb_child.cached_geo_search = child
          bb_child.submission = n.submission
          bb_child.parent = parent_bbox
          bb_child.save!

          if !hierarchy_each_node[child].blank?
            puts "**** #{child.address} has more children"
            new_parents_with_children << bb_child
          end
        end
      end

      parents_with_children = new_parents_with_children
      break if parents_with_children.blank?
    end


    

  end
  
  
  
  private
  #Find the number of parents for a bounding box tree
  def depth(bbox_tree)
    counter = 0
    current_bbox = bbox_tree
    while !current_bbox.parent.blank?
      current_bbox = current_bbox.parent
      counter = counter + 1
    end
    counter
  end

end
