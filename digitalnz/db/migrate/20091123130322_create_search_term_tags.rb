class CreateSearchTermTags < ActiveRecord::Migration
  def self.up
    create_table :search_term_tags do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :search_term_tags
  end
end
