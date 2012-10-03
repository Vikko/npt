class Listener
  
  after_initialize :listen
  attr_accessor :read, :delay, :buffer
  
  def initialize
    puts "Listen to Pipe starting"
    #mkfifo /tmp/pipe
    input = File.open("/tmp/pipe", "r+")
    @buffer = ValueBuffer.new
    return @buffer
  end
  
  def listen
    while READ
      @read = 1
      i = 0 
      @delay = 10
      @buffer.add(input.gets)
      sleep (delay.to_f / 1000)
      if ((i % 4) == 0)
        puts "listening to pipe for " + i.to_s + " frames."
        puts "current buffer: " + @buffer.array.to_s
      end
      i += 1
    end
  end
end
