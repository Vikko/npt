class RawMeasurement < ActiveRecord::Base
  attr_accessible :measurement_time, :sensor_type, :value1, :value2, :value3 
  
  validates_presence_of :measurement_time, :sensor_type, :value1, :value2, :value3 
  
  scope :between, lambda {|from,to| where("time > ? AND time < ?", from, to)}
end
