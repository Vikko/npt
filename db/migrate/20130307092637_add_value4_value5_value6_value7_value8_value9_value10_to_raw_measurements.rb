class AddValue4Value5Value6Value7Value8Value9Value10ToRawMeasurements < ActiveRecord::Migration
  def change
    add_column :raw_measurements, :value4, :float
    add_column :raw_measurements, :value5, :float
    add_column :raw_measurements, :value6, :float
    add_column :raw_measurements, :value7, :float
    add_column :raw_measurements, :value8, :float
    add_column :raw_measurements, :value9, :float
    add_column :raw_measurements, :value10, :float
  end
end
