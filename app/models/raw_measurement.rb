class RawMeasurement < ActiveRecord::Base
  attr_accessible :time, :type, :value1, :value2, :value3
  
  scope :between, lambda {|from,to| where("time > ? AND time < ?", from, to)}
end
