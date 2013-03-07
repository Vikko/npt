class ValueBuffer
  attr_accessor :array, :max_array_size, :bpm
  
  def initialize(type)
    @array = []
    @max_array_size = 100
    @bpm = 0
    @timer = 0
    @type = type
  end  
  
  def add(input)
    case @type
    when GEOLOCATION
      lat = input.value1
      long = input.value2
      @array << [lat.to_f, long.to_f]
    when SWEAT
      @array << input.value1
    when MUSCLETENSION
      @array << input.value1
    when ACCELEROMETER
      @array << [input.value1.to_f, input.value2.to_f, input.value3.to_f]
    when GYROSCOPE
      @array << [input.value1.to_f, input.value2.to_f, input.value3.to_f]
    when HEARTRATE
      @array << input.value1.to_f
      if @array.size > 0
        @bpm = analyse_data
      end
    when RESPIRATION
      @array << input.value1.to_f
    when PEAKACCEL
      @array << input.value1.to_f
    when POSTURE
      @array << input.value1.to_f
    when EEG
      attention = input.value1.to_f
      meditation = input.value2.to_f
      delta = input.value3.to_f
      theta = input.value4.to_f
      lowalpha = input.value5.to_f
      highalpha = input.value6.to_f
      lowbeta = input.value7.to_f
      highbeta = input.value8.to_f
      lowgamma = input.value9.to_f
      midgamma = input.value10.to_f
      @array << [attention, meditation, delta, theta, lowalpha, highalpha, lowbeta, highbeta, lowgamma, midgamma]
    else
      # nothing
    end
    while @array.size > @max_array_size
      @array.delete_at(0) #drop first packets until buffer size <= 100
    end
    return @array
    
  end
  
  def analyse_data
    (@array.size > 10) ? array = @array[(@array.size - 10)..@array.size] : array = @array
    sum = 0
    i = 0
    array.each do |el|
      sum += el
      i += 1
    end
    return (sum / i)
  end
  
  def size
    return @array.size
  end

  def get_array
    if @array.size > 0
      return @array.delete_at(0)
    else
      return nil
    end
  end
  
  def get_data
    return_value = []
    i=0
    size = RawMeasurement.data_size(@type)
    @array.each do |entry|
      if (size == 10)
        return_value << [[i, entry[0]], [i, entry[1]], [entry[2], entry[3], entry[4], entry[5], entry[6], entry[7], entry[8], entry[9]]]
      elsif (size == 3)
        return_value << [[i, entry[0]], [i, entry[1]], [i, entry[2]]]
      elsif (size == 2)
        return_value << [entry[0], entry[1]]
      else #(size == 1)
        return_value << [i, entry[0]]
      end
      i += 1
    end
    return return_value
  end  
end