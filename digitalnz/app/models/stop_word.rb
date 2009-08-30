class StopWord < ActiveRecord::Base
  
  validates_uniqueness_of :word
  
  #Check we have no capital letters
  def validate
    errors.add(:word, "must be lowercase")  if word.downcase != word
  end
end
