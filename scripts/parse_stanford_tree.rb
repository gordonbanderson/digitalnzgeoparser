require 'rubygems'
require 'tree'

file = ARGV[0]

puts "Parsing #{file}"

text=''

ctr = 0

f = File.new(file, "r")
current_node = nil

current_branch = []
firstline = true
root = Tree::TreeNow.new("ROOT", "ROOT")
current_branch.push root
waiting_for_space = false

while (line = f.gets)
  if firstline
    firstline = false
    next
  end
  l = line.strip
  puts "LINE:#{l}"
    
  l.each_byte { |c|
    puts c.chr
    
    # Create a new child?
    if (l == '(')
      waiting_for_space = true
    elsif (l == ' ')
      
    end
  }
end


=begin

cf http://grammarbrowser.sourceforge.net/capture/grammarbrowser-tree.png

(ROOT [52.630]
  (S [52.524]
    (NP [4.268] (PRP [3.018] He))
    (VP [42.087] (VBZ [1.622] says)
      (SBAR [35.699] (IN [0.637] that)
        (S [34.736]
          (NP [4.591] (PRP [3.341] you))
          (VP [29.813] (VBP [5.773] like)
            (S [19.073]
              (VP [18.808] (TO [0.011] to)
                (VP [18.779] (VB [15.730] swim))))))))))
=end

