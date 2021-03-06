class Addstopwords < ActiveRecord::Migration
  def self.up
    
    #These are not thrown at the google geocoder as they are too noisy
    
    StopWord::create :word=>'while'
    StopWord::create :word=>'january'
    StopWord::create :word=>'february'
    StopWord::create :word=>'march'
    StopWord::create :word=>'april'
    StopWord::create :word=>'may'
    StopWord::create :word=>'june'
    StopWord::create :word=>'july'
    StopWord::create :word=>'august'
    StopWord::create :word=>'september'
    StopWord::create :word=>'october'
    StopWord::create :word=>'november'
    StopWord::create :word=>'december'
    StopWord::create :word=>'department'
    StopWord::create :word=>'when'
    StopWord::create :word=>'what'
    StopWord::create :word=>'north'
    StopWord::create :word=>'south'
    StopWord::create :word=>'plenty'
    StopWord::create :word=>'hutt'
    StopWord::create :word=>'they'
    StopWord::create :word=>'some'
    StopWord::create :word=>'king'
    StopWord::create :word=>'islands'
    StopWord::create :word=>'company'
    StopWord::create :word=>'city'
    StopWord::create :word=>'christianity'
    StopWord::create :word=>'from'
    StopWord::create :word=>'maori'
    StopWord::create :word=>'several'
    StopWord::create :word=>'during'
    StopWord::create :word=>'this'
    StopWord::create :word=>'southern'
    StopWord::create :word=>'northern'
    StopWord::create :word=>'eastern'
    StopWord::create :word=>'western'
    StopWord::create :word=>'after'
    StopWord::create :word=>'arrival'
    StopWord::create :word=>'their'
    StopWord::create :word=>'there'
    StopWord::create :word=>'then'
    StopWord::create :word=>'very'
    StopWord::create :word=>'luckily'
    StopWord::create :word=>'scottish'
    StopWord::create :word=>'police'
    StopWord::create :word=>'port'
    StopWord::create :word=>'everyone'
    StopWord::create :word=>'everything'
    StopWord::create :word=>'european'
    StopWord::create :word=>'lounge'
    StopWord::create :word=>'looking'
    StopWord::create :word=>'photograph'
    StopWord::create :word=>'hills'
    StopWord::create :word=>'I d'
    StopWord::create :word=>'promoting'
    StopWord::create :word=>'rates'
    StopWord::create :word=>'strikes'
    StopWord::create :word=>'august'
    StopWord::create :word=>'automobiles'
    StopWord::create :word=>'harbours'
    StopWord::create :word=>'roof'
    StopWord::create :word=>'page'
    StopWord::create :word=>'right'
    StopWord::create :word=>'steam'
    
  end

  def self.down
    StopWord.find(:all).map{|s| s.destroy}
  end
end
