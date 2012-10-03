desc 'Listens to pipe and does stuff'
task :listen_to_pipe => :environment do
  puts "Listen to Pipe starting"
  #mkfifo /tmp/pipe
  input = File.open("/tmp/pipe", "r+")
  buffer = ValueBuffer.new
  READ = 1
  i = 0 
  delay = 10
  while READ
    buffer.add(input.gets)
    sleep (delay.to_f / 1000)
    if ((i % 4) == 0)
      puts "listening to pipe for " + i.to_s + " frames."
      puts "current buffer: " + buffer.array.to_s
    end
    i += 1
  end
end