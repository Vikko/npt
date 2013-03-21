class SensorsController < ApplicationController
  
  def index
    if Thread.main[:listener] == nil
      start
    end
    get_data
  end

  def start
    if Thread.main[:listener] == nil
      Thread.main[:listener] = Listener.new 
    end
    if Thread.main[:listener].read != 1
      Thread.main[:listener].read = 1
      Thread.main[:listener].listen
    end
  end
  
  def stop
    Thread.main[:listener].read = 0
  end
  
  def get_data 
    @listener = Thread.main[:listener]
    @limit = 100
    if @listener.hr_buffer.array.present?
      @hr_data = @listener.hr_buffer.array
      @bpm = @listener.hr_buffer.bpm
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
    if @listener.peac_buffer.array.present?
      @peak_accel_data = @listener.peac_buffer.array
    end
    if @listener.post_buffer.array.present?
      @posture_data = @listener.post_buffer.array
    end
    if @listener.resp_buffer.array.present?
      @respiration_data = @listener.resp_buffer.array
    end
    if @listener.eeg_buffer.array.present?
      @eeg_data = @listener.eeg_buffer.array
    end
  end
  
  def post_data
    Rails.logger.warn("========== PARAMETERS: " + params.inspect)
    not_saved = false
    if params["latitude"] && params["longitude"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => GEOLOCATION, 
                                    :value1 => params["latitude"].to_f, 
                                    :value2 => params["longitude"].to_f)
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["GSR"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => SWEAT, 
                                    :value1 => params["GSR"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["EMG"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => MUSCLETENSION, 
                                    :value1 => params["EMG"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["AccelerometerX"] && params["AccelerometerY"] && params["AccelerometerZ"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => ACCELEROMETER, 
                                    :value1 => params["AccelerometerX"], 
                                    :value2 => params["AccelerometerY"], 
                                    :value3 => params["AccelerometerZ"])      
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["GyroscopeX"] && 
      params["GyroscopeY"] && params["GyroscopeZ"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => GYROSCOPE, 
                                    :value1 => params["GyroscopeX"], 
                                    :value2 => params["GyroscopeY"], 
                                    :value3 => params["GyroscopeZ"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["HEARTBIT"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => HEARTRATE, 
                                    :value1 => params["HEARTBIT"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["RESPIRATION"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => RESPIRATION, 
                                    :value1 => params["RESPIRATION"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["PEAKACCE"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => PEAKACCEL, 
                                    :value1 => params["PEAKACCE"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if params["POSTURE"]
      measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                    :measurement_time => Time.at(params["time"].to_f / 1000), 
                                    :sensor_type => POSTURE, 
                                    :value1 => params["POSTURE"])
      if measure.valid? && RawMeasurement.count < 10000
        measure.save 
      else
        not_saved = true
      end
    end
    if (params["ATTENTION"] && 
        params["MEDITATION"] && 
        params["DELTA"] && 
        params["THETA"] && 
        params["LOWALPHA"] && 
        params["HIGHALPHA"] && 
        params["LOWBETA"] && 
        params["HIGHBETA"] && 
        params["LOWGAMMA"] && 
        params["MIDGAMMA"])
        measure = RawMeasurement.new(:source_id => params["id_sensor"], 
                                      :measurement_time => Time.at(params["time"].to_f / 1000), 
                                      :sensor_type => EEG, 
                                      :value1 => params["ATTENTION"].to_f, 
                                      :value2 => params["MEDITATION"].to_f,
                                      :value3 => params["DELTA"].to_f,
                                      :value4 => params["THETA"].to_f,
                                      :value5 => params["LOWALPHA"].to_f,
                                      :value6 => params["HIGHALPHA"].to_f,
                                      :value7 => params["LOWBETA"].to_f,
                                      :value8 => params["HIGHBETA"].to_f,
                                      :value9 => params["LOWGAMMA"].to_f,
                                      :value10 => params["MIDGAMMA"].to_f)
        if measure.valid? && RawMeasurement.count < 10000
          measure.save 
        else
          not_saved = true
        end
      end
      begin 
      if not_saved 
        render :json => {"saved" => false, "id" => measure.source_id}
      else
        render :json => {"saved" => true, "id" => measure.source_id};
      end
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