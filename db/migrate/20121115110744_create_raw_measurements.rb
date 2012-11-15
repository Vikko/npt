class CreateRawMeasurements < ActiveRecord::Migration
  def change
    create_table :raw_measurements do |t|
      t.datetime :time, :limit => 53
      t.integer :type
      t.float :value1
      t.float :value2
      t.float :value3

      t.timestamps
    end
  end
end
