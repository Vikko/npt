class Listener
  
  include Spawn
  
  attr_accessor :read, :delay, :hr_buffer, :sw_buffer, :mt_buffer, :accel_buffer, :gyro_buffer, :geo_buffer, :resp_buffer, :peac_buffer, :post_buffer, :eeg_buffer
  
  def initialize
    Thread.main[:hr_buffer] = ValueBuffer.new(HEARTRATE)
    Thread.main[:sw_buffer] = ValueBuffer.new(SWEAT)
    Thread.main[:mt_buffer] = ValueBuffer.new(MUSCLETENSION)
    Thread.main[:accel_buffer] = ValueBuffer.new(ACCELEROMETER)
    Thread.main[:gyro_buffer] = ValueBuffer.new(GYROSCOPE)
    Thread.main[:geo_buffer] = ValueBuffer.new(GEOLOCATION)
    Thread.main[:resp_buffer] = ValueBuffer.new(RESPIRATION)
    Thread.main[:peac_buffer] = ValueBuffer.new(PEAKACCEL)
    Thread.main[:post_buffer] = ValueBuffer.new(POSTURE)
    Thread.main[:eeg_buffer] = ValueBuffer.new(EEG)
  end
  
  def listen
    spawn_block(:method => :thread) do 
      listen_thread
    end
  end
  
  def listen_thread
    while @read == 1
      @delay = 500
      buffer = (1).seconds
      to = Time.now - buffer
      from = to - (@delay.to_f / 1000)
      data = RawMeasurement.between(from, to)
      data.each do |entry|
        case entry.sensor_type
        when HEARTRATE
          Thread.main[:hr_buffer].add(entry)
        when SWEAT
          Thread.main[:sw_buffer].add(entry)
        when MUSCLETENSION
          Thread.main[:mt_buffer].add(entry)
        when ACCELEROMETER
          Thread.main[:accel_buffer].add(entry)
        when GYROSCOPE
          Thread.main[:gyro_buffer].add(entry)
        when GEOLOCATION
          Thread.main[:geo_buffer].add(entry)
        when RESPIRATION
          Thread.main[:resp_buffer].add(entry)
        when PEAKACCEL
          Thread.main[:peac_buffer].add(entry)
        when POSTURE
          Thread.main[:post_buffer].add(entry)
        when EEG
          Thread.main[:eeg_buffer].add(entry)
        end
      end
      sleep (@delay.to_f / 1000)
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done