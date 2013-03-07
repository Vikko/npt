class RawMeasurement < ActiveRecord::Base
  attr_accessible :source_id, :measurement_time, :sensor_type, :value1, :value2, :value3, :value4, :value5, :value6, :value7, :value8, :value9, :value10 
    
  validates_presence_of :measurement_time, :sensor_type, :value1
  validate :value2, :presence => true, :if => Proc.new{|m| [EEG, GEOLOCATION, ACCELEROMETER, GYROSCOPE].include?(m.sensor_type)}
  validate :value3, :presence => true, :if => Proc.new{|m| [EEG, ACCELEROMETER, GYROSCOPE].include?(m.sensor_type)}
  validate :value4, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value5, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value6, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value7, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value8, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value9, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
  validate :value10, :presence => true, :if => Proc.new{|m| [EEG].include?(m.sensor_type)}
        
  scope :between, lambda {|from,to| where("measurement_time > ? AND measurement_time <= ?", from, to)}
  
  def self.data_size(sensor_type)
    if [EEG].include?(sensor_type)
      return 10
    elsif [ACCELEROMETER, GYROSCOPE].include?(sensor_type)
      return 3
    elsif [GEOLOCATION].include?(sensor_type)
      return 2
    else
      return 1
    end
  end
end
