class PhraseFrequency < ActiveRecord::Base
  belongs_to :submission
  belongs_to :phrase
  
  validates_presence_of :phrase,:submission
end
