class Phrase < ActiveRecord::Base
  belongs_to :submission
  has_many :phrase_frequency
  
  #validates_uniqueness_of :words
  has_many :filtered_phrases
  
  def self.find_or_create(words)
    p = Phrase.find_by_words(words)
    if p.blank?
      p = Phrase::create :words => words
      p.save
    end
    p
  end
end
