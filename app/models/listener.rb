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
    i = 0 
    while @read == 1
      @delay = 100
      buffer = 10.seconds
      to = Time.now - buffer
      from = to - 0.1
      ActiveRecord::Base.connection_pool.with_connection do 
        puts(" == Getting data == ")
        data = RawMeasurement.between(from, to)
        puts(data.inspect)
      end
      data.each do |entry|
        @buffer.add("0,#{entry.value1},#{entry.value2}")
      end
      # if data.present?
      #   prev = data
      # else 
      #   data = prev
      # end
      # @buffer.add(data.) 
      sleep (@delay.to_f / 1000)
      # if ((i % 50) == 0)
      # puts "COUNT: #{i}"
      # end
      i += 1
      ActiveRecord::Base.verify_active_connections!() if defined? ActiveRecord
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done
