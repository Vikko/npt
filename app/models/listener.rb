class Listener
  
  attr_accessor :read, :delay, :buffer
  
  def initialize
    puts "Listen to Pipe starting"
    #mkfifo /tmp/pipe
    @input = File.open("/tmp/pipe", "r+")
    @buffer = ValueBuffer.new
    @threads = []
  end
  
  def listen
    @threads << Thread.new do
      listen_thread
    end
  end
  
  def listen_thread
    while @read
      @read = 1
      i = 0 
      @delay = 20
      @buffer.add(@input.gets)
      sleep (@delay.to_f / 1000)
      if ((i % 4) == 0)
        puts "listening to pipe for " + i.to_s + " frames."
      end
      i += 1
    end
  end
end
