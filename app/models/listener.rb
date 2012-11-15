class Listener
  
  include Spawn
  
  attr_accessor :read, :delay, :buffer
  
  def initialize
    @buffer = ValueBuffer.new
  end
  
  def listen
    spawn_block(:method => :thread) do 
      listen_thread
    end
  end
  
  def listen_thread
    while @read == 1
      @delay = 100
      buffer = 10.seconds
      to = Time.now - buffer
      from = to - 0.1
      # puts(" == Getting data == ")
      data = RawMeasurement.between(from, to)
      # puts(data.inspect)
      data.each do |entry|
        @buffer.add("0,#{entry.value1},#{entry.value2}")
      end
      sleep (@delay.to_f / 1000)
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done