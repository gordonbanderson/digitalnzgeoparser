class CalaisEntry < ActiveRecord::Base
  belongs_to :child_word, :class_name => 'CalaisWord', :foreign_key => 'calais_child_word_id'
  belongs_to :parent_word, :class_name => 'CalaisWord', :foreign_key => 'calais_parent_word_id'
  
  validates_presence_of :child_word, :parent_word
  
  #Print out for debug purposes
  def pretty_print
     "#{parent_word.word} ==> #{child_word.word}" 
  end
end
