class Listener
  
  include Spawn
  
  attr_accessor :read, :delay
  
  def initialize
    @delay = 500
    unless Rails.cache.read(:hr_buffer).present?
      Rails.cache.write(:hr_buffer, ValueBuffer.new(HEARTRATE), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:sw_buffer).present?
      Rails.cache.write(:sw_buffer, ValueBuffer.new(SWEAT), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:mt_buffer).present?
      Rails.cache.write(:mt_buffer, ValueBuffer.new(MUSCLETENSION), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:accel_buffer).present?
      Rails.cache.write(:accel_buffer, ValueBuffer.new(ACCELEROMETER), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:gyro_buffer).present?
      Rails.cache.write(:gyro_buffer, ValueBuffer.new(GYROSCOPE), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:geo_buffer).present?
      Rails.cache.write(:geo_buffer, ValueBuffer.new(GEOLOCATION), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:resp_buffer).present?
      Rails.cache.write(:resp_buffer, ValueBuffer.new(RESPIRATION), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:peac_buffer).present?
      Rails.cache.write(:peac_buffer, ValueBuffer.new(PEAKACCEL), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:post_buffer).present?
      Rails.cache.write(:post_buffer, ValueBuffer.new(POSTURE), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
    unless Rails.cache.read(:eeg_buffer).present?
      Rails.cache.write(:eeg_buffer, ValueBuffer.new(EEG), :time_to_idle => 1.day, :timeToLive => 1.day)
    end
  end
  
  def hr_buffer
    Rails.cache.read(:hr_buffer)
  end
  
  def sw_buffer
    Rails.cache.read(:sw_buffer)
  end
  
  def mt_buffer
    Rails.cache.read(:mt_buffer)
  end
  
  def accel_buffer
    Rails.cache.read(:accel_buffer)
  end
  
  def gyro_buffer
    Rails.cache.read(:gyro_buffer)
  end
  
  def geo_buffer
    Rails.cache.read(:geo_buffer)
  end
  
  def resp_buffer
    Rails.cache.read(:resp_buffer)
  end
  
  def peac_buffer
    Rails.cache.read(:peac_buffer)
  end
  
  def post_buffer
    Rails.cache.read(:post_buffer)
  end
  
  def eeg_buffer
    Rails.cache.read(:eeg_buffer)
  end
  
  def listen
    spawn_block(:method => :thread) do 
      listen_thread
    end
  end
  
  def listen_thread
    while @read == 1
      @delay = 500
      buffer = (1.5).seconds
      to = Time.now - buffer
      from = to - (@delay.to_f / 1000)
      data = RawMeasurement.between(from, to)
      data.each do |entry|
        case entry.sensor_type
        when HEARTRATE
          Rails.cache.read(:hr_buffer).add(entry)
        when SWEAT
          Rails.cache.read(:sw_buffer).add(entry)
        when MUSCLETENSION
          Rails.cache.read(:mt_buffer).add(entry)
        when ACCELEROMETER
          Rails.cache.read(:accel_buffer).add(entry)
        when GYROSCOPE
          Rails.cache.read(:gyro_buffer).add(entry)
        when GEOLOCATION
          Rails.cache.read(:geo_buffer).add(entry)
        when RESPIRATION
          Rails.cache.read(:resp_buffer).add(entry)
        when PEAKACCEL
          Rails.cache.read(:peac_buffer).add(entry)
        when POSTURE
          Rails.cache.read(:post_buffer).add(entry)
        when EEG
          Rails.cache.read(:eeg_buffer).add(entry)
        end
      end
      sleep (@delay.to_f / 1000)
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done