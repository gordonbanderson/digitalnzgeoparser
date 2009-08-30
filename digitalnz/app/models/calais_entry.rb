class CalaisEntry < ActiveRecord::Base
  belongs_to :calais_submission
  belongs_to :calais_child_word
  belongs_to :calais_parent_word
end
