class AvoidDuplicatesWithIndexes < ActiveRecord::Migration
  
  #Enforce unique names at the database level
  def self.up
      add_index :subjects, :name, :unique => true #Tested
      add_index :collections, :name, :unique => true
      add_index :coverages, :name, :unique => true      
      add_index :creators, :name, :unique => true
      add_index :contributors, :name, :unique => true
      add_index :languages, :name, :unique => true
      add_index :placenames, :name, :unique => true
      
      add_index :publishers, :name, :unique => true
      add_index :formats, :name, :unique => true
      add_index :identifiers, :name, :unique => true
      
      #DONE ALREADY add_index :calais_words, :word, :unique => true
      add_index :categories, :name, :unique => true
      add_index :content_partners, :name, :unique => true
      #DONE ALREADY add_index :phrases, :words, :unique => true
      add_index :relations, :name, :unique => true
      add_index :rights, :name, :unique => true      

  end

  def self.down
      remove_index :subjects, :name
      remove_index :collections, :name
      remove_index :coverages, :name
      
      remove_index :creators, :name
      remove_index :contributors, :name
      remove_index :languages, :name
      remove_index :placenames, :name
      
      remove_index :publishers, :name
      remove_index :formats, :name
      remove_index :identifiers, :name
  end
end
