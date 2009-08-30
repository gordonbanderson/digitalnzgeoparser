class PhraseFrequency < ActiveRecord::Base
  belongs_to :submission
  belongs_to :phrase
end
