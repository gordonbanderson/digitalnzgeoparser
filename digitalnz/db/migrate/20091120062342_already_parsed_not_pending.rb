class AlreadyParsedNotPending < ActiveRecord::Migration
  def self.up
    for s in Submission.find(:all)
        n = s.natlib_metadata
        n.pending = false #already parsed
        n.save!
    end
  end

  def self.down
  end
end
