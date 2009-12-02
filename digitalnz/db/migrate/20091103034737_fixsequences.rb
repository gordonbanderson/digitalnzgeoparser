class Fixsequences < ActiveRecord::Migration
  def self.up
    sql = ActiveRecord::Base.connection()
    #sql.begin_db_transaction

# alter sequence natlib_metadatas_id_seq1 restart (select max(id) from facet_fields);
    #This is postgres specific
    f = FacetField.find(:last)
    n = NatlibMetadata.find(:last)
    
    puts f.to_yaml
    puts n.to_yaml
    
    class_name = ActiveRecord::Base.connection().class
    
    #MYSQL seems to have the right id values automatically
    if class_name == 'ActiveRecord::ConnectionAdapters::MysqlAdapter:Class'
        #Do not alter the sequences if we are creating from scratch (ie a first install migration)
        sql.execute("alter sequence natlib_metadatas_id_seq1 restart #{1+n.id};") if !n.blank?
        sql.execute("alter sequence facet_fields_id_seq1 restart #{1+f.id}") if !f.blank?
    end
    

    #sql.commit_db_transaction
  end

  def self.down
  end
end
