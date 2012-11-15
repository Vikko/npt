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
      buffer = 5.seconds
      to = Time.now - buffer
      from = to - (@delay.to_f / 1000)
      # puts(" == Getting data == ")
      data = RawMeasurement.between(from, to)
      # puts(data.inspect)
      data.each do |entry|
        if HEARTRATE
          @hr_buffer.add(entry)
        elsif SWEAT
          
        elsif MUSCLETENSION
          
        elsif ACCELEROMETER
          
        elsif GYROSCOPE
          
        elsif GEOLOCATION
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