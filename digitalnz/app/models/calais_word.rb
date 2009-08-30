class CalaisWord < ActiveRecord::Base
  has_one :calais_parent_word
  has_one :calais_child_word
end
