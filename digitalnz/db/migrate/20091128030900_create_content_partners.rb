class CreateContentPartners < ActiveRecord::Migration
  def self.up
    create_table :content_partners do |t|
      t.string :name
      t.string :permalink
      t.timestamps
    end
    
    #MIgrate from natlib metadatas
  end

  def self.down
    drop_table :content_partners
  end
end
