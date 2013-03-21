class Listener
  
  include Spawn
  
  attr_accessor :read, :delay
  
  def initialize
    unless Rails.cache[:hr_buffer].present?
      Rails.cache[:hr_buffer] = ValueBuffer.new(HEARTRATE)
    end
    unless Rails.cache[:sw_buffer].present?
      Rails.cache[:sw_buffer] = ValueBuffer.new(SWEAT)
    end
    unless Rails.cache[:mt_buffer].present?
      Rails.cache[:mt_buffer] = ValueBuffer.new(MUSCLETENSION)
    end
    unless Rails.cache[:accel_buffer].present?
      Rails.cache[:accel_buffer] = ValueBuffer.new(ACCELEROMETER)
    end
    unless Rails.cache[:gyro_buffer].present?
      Rails.cache[:gyro_buffer] = ValueBuffer.new(GYROSCOPE)
    end
    unless Rails.cache[:geo_buffer].present?
      Rails.cache[:geo_buffer] = ValueBuffer.new(GEOLOCATION)
    end
    unless Rails.cache[:resp_buffer].present?
      Rails.cache[:resp_buffer] = ValueBuffer.new(RESPIRATION)
    end
    unless Rails.cache[:peac_buffer].present?
      Rails.cache[:peac_buffer] = ValueBuffer.new(PEAKACCEL)
    end
    unless Rails.cache[:post_buffer].present?
      Rails.cache[:post_buffer] = ValueBuffer.new(POSTURE)
    end
    unless Rails.cache[:eeg_buffer].present?
      Rails.cache[:eeg_buffer] = ValueBuffer.new(EEG)
    end
  end
  
  def hr_buffer
    Rails.cache[:hr_buffer]
  end
  
  def sw_buffer
    Rails.cache[:sw_buffer]
  end
  
  def mt_buffer
    Rails.cache[:mt_buffer]
  end
  
  def accel_buffer
    Rails.cache[:accel_buffer]
  end
  
  def gyro_buffer
    Rails.cache[:gyro_buffer]
  end
  
  def geo_buffer
    Rails.cache[:geo_buffer]
  end
  
  def resp_buffer
    Rails.cache[:resp_buffer]
  end
  
  def peac_buffer
    Rails.cache[:peac_buffer]
  end
  
  def post_buffer
    Rails.cache[:post_buffer]
  end
  
  def eeg_buffer
    Rails.cache[:eeg_buffer]
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
          Rails.cache[:hr_buffer].add(entry)
        when SWEAT
          Rails.cache[:sw_buffer].add(entry)
        when MUSCLETENSION
          Rails.cache[:mt_buffer].add(entry)
        when ACCELEROMETER
          Rails.cache[:accel_buffer].add(entry)
        when GYROSCOPE
          Rails.cache[:gyro_buffer].add(entry)
        when GEOLOCATION
          Rails.cache[:geo_buffer].add(entry)
        when RESPIRATION
          Rails.cache[:resp_buffer].add(entry)
        when PEAKACCEL
          Rails.cache[:peac_buffer].add(entry)
        when POSTURE
          Rails.cache[:post_buffer].add(entry)
        when EEG
          Rails.cache[:eeg_buffer].add(entry)
        end
      end
      sleep (@delay.to_f / 1000)
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done