class Fixsequences < ActiveRecord::Migration
  def self.up
    sql = ActiveRecord::Base.connection()
    sql.begin_db_transaction

# alter sequence natlib_metadatas_id_seq1 restart (select max(id) from facet_fields);
    #This is postgres specific
    f = FacetField.find(:last)
    n = NatlibMetadata.find(:last)
    sql.execute("alter sequence natlib_metadatas_id_seq1 restart #{1+n.id};")
    sql.execute("alter sequence facet_fields_id_seq1 restart #{1+f.id}")
    sql.commit_db_transaction
  end

  def self.down
  end
end
