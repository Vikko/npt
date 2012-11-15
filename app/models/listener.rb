class Listener
  
  include Spawn
  
  attr_accessor :read, :delay, :hr_buffer, :geo_buffer
  
  def initialize
    @hr_buffer = ValueBuffer.new(HEARTRATE)
    @geo_buffer = ValueBuffer.new(GEOLOCATION)
  end
  
  def listen
    spawn_block(:method => :thread) do 
      listen_thread
    end
  end
  
  def listen_thread
    while @read == 1
      @delay = 500
      buffer = 1.seconds
      to = Time.now - buffer
      from = to - (@delay.to_f / 1000)
      # puts(" == Getting data == ")
      data = RawMeasurement.between(from, to)
      # puts(data.inspect)
      data.each do |entry|
        case entry.sensor_type
        when HEARTRATE
          @hr_buffer.add(entry)
        when SWEAT
          
        when MUSCLETENSION
          
        when ACCELEROMETER
          @hr_buffer.add(entry)
        when GYROSCOPE
          
        when GEOLOCATION
          @geo_buffer.add(entry)
        end
      end
      sleep (@delay.to_f / 1000)
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done