class FilteredPhrase < ActiveRecord::Base
  belongs_to :phrase
  belongs_to :filter_type
  
  has_and_belongs_to_many :submissions
  
  
  def self.find_or_create(phrase, filter_type)
    filtered_phrase = FilteredPhrase.find(:first, 
      :conditions =>["phrase_id=? and filter_type_id=?", phrase.id, filter_type.id])
    if filtered_phrase.blank?
      filtered_phrase = FilteredPhrase::create :phrase=>phrase, :filter_type => filter_type
      filtered_phrase.save!
    end
    
    filtered_phrase
    
  end
end
