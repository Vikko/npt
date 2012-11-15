class RenameRawMeasurementTypeToSensorType < ActiveRecord::Migration
  def up
    rename_column :raw_measurements, :type, :sensor_type
  end

  def down
    rename_column :raw_measurements, :sensor_type, :type
  end
end
