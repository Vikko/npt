class SensorsController < ApplicationController

  @@listener = nil
  @@buffer = nil
  

  def index
    if @@listener.blank? 
      # start
    end
    get_data
  end

  def start
    if @@listener == nil
      @@listener = Listener.new
      @@buffer = @@listener.buffer    
    end
    if @@listener.read != 1
      @@listener.listen
      @@listener.read = 1
    end
  end
  
  def stop
    @@listener.read = 0
  end
  
  def get_data 
    @buffer = @@buffer
    @listener = @@listener
    @data = @buffer.full_data if @buffer
  end
  
end