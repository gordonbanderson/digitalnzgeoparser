class CreateRecordDates < ActiveRecord::Migration
  def self.up
    create_table :record_dates do |t|
      t.date :start_date
      t.date :end_date
      t.integer :natlib_metadata_id

      t.timestamps
    end
  end

  def self.down
    drop_table :record_dates
  end
end
