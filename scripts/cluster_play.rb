#!/usr/bin/env ../digitalnz/script/runner
record = ARGV[0]


def cluster_fuck(cached_geo_searches)
  result = {}
  for blocksize in 1..32

    puts
    puts "NEXT BLOCK SIZE: #{blocksize}"
    result[blocksize]={}
    for location in cached_geo_searches
      latgridpos = (location.latitude/blocksize).round
      longridpos = (location.longitude/blocksize).round
      
      #Do we have the lat stored?
      if result[blocksize][latgridpos].blank?
        result[blocksize][latgridpos]={}
      end
      
      #Do we have the lon stored?  If not initialise the counter to 1
      if result[blocksize][latgridpos][longridpos].blank?
        result[blocksize][latgridpos][longridpos] = 1
      else
        nextval = 1 + result[blocksize][latgridpos][longridpos]
        result[blocksize][latgridpos][longridpos] = nextval
      end
      

      latpos = blocksize*latgridpos
      lonpos = blocksize*longridpos
      
      puts "LOCATION: #{location.cached_geo_search_term.search_term} -   #{location.longitude}, #{location.latitude} (#{longridpos},#{latgridpos}) (#{result[blocksize][latgridpos][longridpos]})"
    end
    
    
    
    
    puts "CLUSTER"
    puts "CLUSTER*******#{blocksize}*****:\n\n"
    
    for latkey in result[blocksize].keys.sort
      for lonkey in result[blocksize][latkey].keys.sort
        hits = result[blocksize][latkey][lonkey]
        
        puts "CLUSTER FILT:(#{lonkey*blocksize}, #{latkey*blocksize}) = #{hits}... BLOCKSIZE=#{blocksize}"
      end
    end
  end
end

puts record

nl = NatlibMetadata.find_by_natlib_id(record)
s = nl.submission


cluster_fuck(nl.submission.cached_geo_searches)