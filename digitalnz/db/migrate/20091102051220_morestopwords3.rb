class Morestopwords3 < ActiveRecord::Migration
  def self.up
    StopWord::create :word=>'gathering'
    StopWord::create :word=>'forest'
    StopWord::create :word=>'tenth'
    StopWord::create :word=>'river'
    StopWord::create :word=>'otw'
    StopWord::create :word=>'gathering'
    StopWord::create :word=>'oval'
    StopWord::create :word=>'date'
  end

  def self.down
  end
end
