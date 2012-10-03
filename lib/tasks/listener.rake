desc 'Listens to pipe and does stuff'
task :listen_to_pipe => :environment do
  puts "Listen to Pipe starting"
  #mkfifo /tmp/pipe
  input = File.open("/tmp/pipe", "w+")
  READ = 1
  i = 0 
  delay = 10
  while READ
    # ValueBuffer.add(input.gets)
    sleep (delay.to_f / 1000)
    if ((i % 500) == 0)
      puts "listening to pipe for " + (i*delay / 1000).to_s + "s."
    end
    i += 1
  end
end