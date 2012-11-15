class SensorsController < ApplicationController

  @@listener = nil
  @@buffer = nil
  

  def index
    if @@listener.blank? 
      start
    end
    @post_count = Textlogger.count
    get_data
    @logger = Textlogger.all
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
    # RawMeasurement.new(:time = Time.now, :type => 1, :value1 => params[:EMG], :value2 => params[:EMG])
    Textlogger.create(:content => "parameters: #{params.inspect}")
    render :json => {"status" => "ok"};
  end
  
  def test_json
    render :json => {"status" => "ok"}
  end
  
  def delete_all
    Textlogger.destroy_all
    redirect_to :action => :index
  end
  
end