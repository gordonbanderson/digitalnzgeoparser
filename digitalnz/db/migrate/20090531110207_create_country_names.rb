class CreateCountryNames < ActiveRecord::Migration
  def self.up
    create_table :country_names do |t|
      t.integer :country_id
      t.string :name
      t.timestamps
    end
    
    for country in Country.find(:all)
      name = country.name
      cn = CountryName::new
      cn.name = name
      cn.country = country
      cn.save!
    end
    
    #Now add the UK countries
    britain = Country.find_by_abbreviation('GB')
    CountryName.create :name => 'Scotland', :country => britain
    CountryName.create :name => 'England', :country => britain
    CountryName.create :name => 'Northern Ireland', :country => britain
    CountryName.create :name => 'Wales', :country => britain
    
    
    remove_column :countries, :name
  end

  def self.down
    raise Exception
  end
end
