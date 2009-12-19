class CalaisEntry < ActiveRecord::Base
  belongs_to :child_word, :class_name => 'CalaisWord', :foreign_key => 'calais_child_word_id'
  belongs_to :parent_word, :class_name => 'CalaisWord', :foreign_key => 'calais_parent_word_id'
  
  #These pairings belong to submitted texts
  has_and_belongs_to_many :submissions
  
  validates_presence_of :child_word, :parent_word
  
  #Only create a new one if none exists, otehrwise use an existing combo
  def self.find_or_create(parent_calais_word, child_calais_word)
      calais_entry = CalaisEntry.find(:first, :conditions => ["calais_child_word_id = ? and calais_parent_word_id = ?", child_calais_word.id, parent_calais_word.id])
      if calais_entry.blank?
          calais_entry = CalaisEntry::create :child_word => child_calais_word, :parent_word => parent_calais_word
      end
      
      calais_entry
  end
  
  
  def name
      "#{parent_word.word} | #{child_word.word}" 
  end
  
  #Print out for debug purposes
  def pretty_print
     "#{parent_word.word} ==> #{child_word.word}" 
  end
end
