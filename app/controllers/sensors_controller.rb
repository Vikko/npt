class SensorsController < ApplicationController

  @@listener = nil
  @@started = false
  @@buffer = nil
  

  def index
    if @@listener.blank? 
      # start
    end
    @listener = @@listener
    @buffer = @@buffer
  end

  def start
    if @@started == false
      @@started = true
      @@listener = Listener.new
      @@buffer = @@listener.buffer    
    end
    @@listener.read = 1
    @@listener.listen
  end
  
  def stop
    @@listener.read = 0
  end
  
  def update 
    @buffer = @@buffer
    @listener = @@listener
  end
  
end