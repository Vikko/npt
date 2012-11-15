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
    if params["latitude"] && params["longitude"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => GEOLOCATION, :value1 => params["latitude"], :value2 => params["longitude"])
    elsif params["GSR"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => SWEAT, :value1 => params["GSR"])
    elsif params["EMG"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => MUSCLETENSION, :value1 => params["EMG"])
    elsif params["AccelerometerX"] && params["AccelerometerY"] && params["AccelerometerZ"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => ACCELEROMETER, :value1 => params["AccelerometerX"], :value2 => params["AccelerometerY"], :value3 => params["AccelerometerZ"])      
    elsif params["GyroscopeX"] && params["GyroscopeY"] && params["GyroscopeZ"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => GYROSCOPE, :value1 => params["GyroscopeX"], :value2 => params["GyroscopeY"], :value3 => params["GyroscopeZ"])
    elsif params["Heartrate"]
      measure = RawMeasurement.new(:measurement_time => Time.now, :sensor_type => HEARTRATE, :value1 => params["Heartrate"])
    end
    if measure.valid?
      measure.save
    end
    Textlogger.create(:content => "parameters: #{params.inspect}")
    render :json => {"status" => "ok"};
  end
  
  def test_json
    render :json => {"status" => "ok"}
  end
  
  def delete_all
    Textlogger.destroy_all
    RawMeasurement.destroy_all
    redirect_to :action => :index
  end
  
end