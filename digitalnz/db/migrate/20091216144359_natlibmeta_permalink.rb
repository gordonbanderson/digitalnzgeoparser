class NatlibmetaPermalink < ActiveRecord::Migration
  def self.up
      ctr = 0
      #add_column :natlib_metadatas, :permalink, :string
      
      total = NatlibMetadata.count
      page_size = 100
      maxpages = total/page_size
      for i in 0..maxpages
          offset = page_size*i
          puts "LOOP:#{i}, #{offset}"
          for nl in NatlibMetadata.find(:all, :offset => offset, :limit => page_size)
                ctr = ctr + 1

               nl.save! #Update permalink
               if (ctr % 1000) == 0
                   puts "\tSAVED (#{ctr}):#{nl.natlib_id} =< #{nl.permalink}"
               end
            end
      end
      
      puts total
      
      
      
  end

  def self.down
      remove_column :natlib_metadatas, :permalink
      
  end
end
