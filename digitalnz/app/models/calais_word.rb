class CalaisWord < ActiveRecord::Base
    #Permalink for grouping on webpages
    has_permalink :word, :update => true

    has_one :calais_parent_word
    has_one :calais_child_word
    
    #Validations
    validates_presence_of :word
    validates_uniqueness_of :word
  
  
  def self.find_or_create word
    cw = CalaisWord.find_by_word(word)
    cw = CalaisWord::create :word => word   if cw.blank?
    cw  
  end
end
