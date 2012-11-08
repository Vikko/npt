class SensorsController < ApplicationController

  @@listener = nil
  @@buffer = nil
  

  def index
    if @@listener.blank? 
      @@listener = 0
      # start
    end
    @post_count = @@listener
    get_data
  end

  def start
    if @@listener == nil
      @@listener = Listener.new
      @@buffer = @@listener.buffer    
    end
    if @@listener.read != 1
      @@listener.read = 1
      @@listener.listen
    end
  end
  
  def stop
    @@listener.read = 0
  end
  
  def get_data 
    @buffer = @@buffer
    @listener = @@listener
    @hr_data = @buffer.get_data if @buffer
  end
  
  def post_data
    @@listener += 1
    render :json => {"status" => "ok"};
  end
  
  def test_json
    render :json => {"status" => "ok"}
  end
  
end