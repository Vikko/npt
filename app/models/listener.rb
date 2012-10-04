class Listener
  
  attr_accessor :read, :delay, :buffer
  
  def initialize
    puts "Listen to Pipe starting"
    #mkfifo /tmp/pipe
    @input = File.open("/tmp/pipe", "r")
    @buffer = ValueBuffer.new
    @threads = []
  end
  
  def listen
    @threads << Thread.new do
                  listen_thread
                end
  end
  
  def listen_thread
    i = 0 
    while @read == 1
      @delay = 20
      data = @input.gets
      @buffer.add(data) if data.present?
      sleep (@delay.to_f / 1000)
      if ((i % 50) == 0)
        puts "listening to pipe for " + (i/50).to_s + " seconds."
      end
      i += 1
    end
  end
end

# bash to simulate data:
# while true ; do echo "0,$(($RANDOM % 100 + 1000)),$(($RANDOM % 100 + 1050))" | tee /tmp/pipe; sleep 0.02 ; done
