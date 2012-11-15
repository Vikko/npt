class RawMeasurement < ActiveRecord::Base
  attr_accessible :measurement_time, :sensor_type, :value1, :value2, :value3 
    
  validates_presence_of :measurement_time, :sensor_type, :value1
  validate :value2, :presence => true, :if => Proc.new{|m| [GEOLOCATION, ACCELEROMETER, GYROSCOPE].include?(m.sensor_type)}
  validate :value3, :presence => true, :if => Proc.new{|m| [ACCELEROMETER, GYROSCOPE].include?(m.sensor_type)}
  
  scope :between, lambda {|from,to| where("measurement_time > ? AND measurement_time <= ?", from, to)}
end
