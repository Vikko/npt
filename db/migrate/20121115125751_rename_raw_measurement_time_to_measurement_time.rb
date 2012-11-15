class RenameRawMeasurementTimeToMeasurementTime < ActiveRecord::Migration
  def up
    rename_column :raw_measurements, :time, :measurement_time
  end

  def down
    rename_column :raw_measurements, :measurement_time, :time
  end
end
