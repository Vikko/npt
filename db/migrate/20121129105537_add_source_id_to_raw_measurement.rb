class AddSourceIdToRawMeasurement < ActiveRecord::Migration
  def change
    add_column :raw_measurements, :source_id, :integer
  end
end
