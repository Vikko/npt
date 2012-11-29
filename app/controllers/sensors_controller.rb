class SensorsController < ApplicationController

  @@listener = nil
  

  def index
    if @@listener.blank? 
      start
    end
    # @post_count = Textlogger.count
    get_data
  end

  def start
    if @@listener == nil
      @@listener = Listener.new 
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
    @listener = @@listener
    if @listener.hr_buffer.array.present?
      @hr_data = @listener.hr_buffer.array
    end
    if @listener.sw_buffer.array.present?
      @sw_data = @listener.sw_buffer.array
    end
    if @listener.mt_buffer.array.present?
      @mt_data = @listener.mt_buffer.array
    end
    if @listener.accel_buffer.array.present?
      @accel_data = @listener.accel_buffer.array
    end
    if @listener.gyro_buffer.array.present?
      @gyro_data = @listener.gyro_buffer.array
    end
    if @listener.geo_buffer.array.present?
      @latitude, @longitude = @listener.geo_buffer.array.last
    end
  end
  
  def post_data
    Rails.logger.warn("========== PARAMETERS: " + params.inspect)
    saved = []
    not_saved = []
    if params["latitude"] && params["longitude"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => GEOLOCATION, :value1 => params["latitude"], :value2 => params["longitude"])
      if measure.valid? && RawMeasurement.count < 10000
        if measure.save
          saved << measure.source_id
        else 
          not_saved << measure.source_id
        end
      end
    end
    if params["GSR"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => SWEAT, :value1 => params["GSR"])
      if measure.valid? && RawMeasurement.count < 10000
        if measure.save
          saved << measure.source_id
        else 
          not_saved << measure.source_id
        end
      end
    end
    if params["EMG"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => MUSCLETENSION, :value1 => params["EMG"])
      if measure.valid? && RawMeasurement.count < 10000
        if measure.save
          saved << measure.source_id
        else 
          not_saved << measure.source_id
        end      end
    end
    if params["AccelerometerX"] && params["AccelerometerY"] && params["AccelerometerZ"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => ACCELEROMETER, :value1 => params["AccelerometerX"], :value2 => params["AccelerometerY"], :value3 => params["AccelerometerZ"])      
      if measure.valid? && RawMeasurement.count < 10000
         if measure.save
           saved << measure.source_id
         else 
           not_saved << measure.source_id
         end      
      end
    end
    if params["GyroscopeX"] && params["GyroscopeY"] && params["GyroscopeZ"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => GYROSCOPE, :value1 => params["GyroscopeX"], :value2 => params["GyroscopeY"], :value3 => params["GyroscopeZ"])
      if measure.valid? && RawMeasurement.count < 10000
        if measure.save
          saved << measure.source_id
        else 
          not_saved << measure.source_id
        end      
      end
    end
    if params["Heartrate"]
      measure = RawMeasurement.new(:source_id => 1, :measurement_time => Time.at(params["time"].to_f / 1000), :sensor_type => HEARTRATE, :value1 => params["Heartrate"])
      if measure.valid? && RawMeasurement.count < 10000
        if measure.save
          saved << measure.source_id
        else 
          not_saved << measure.source_id
        end
      end
    end
    begin 
      render :json => {"saved" => saved.to_s, "not_saved" => not_saved.to_s};
    rescue Exception => e
      render :json => {"error" => "#{e.message}"}
    end
  end
  
  def test_json
    render :json => {"status" => "ok"}
  end
  
  def delete_all
    Textlogger.delete_all
    RawMeasurement.delete_all
    redirect_to :action => :index
  end
  
end