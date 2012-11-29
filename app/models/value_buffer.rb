class ValueBuffer
  attr_accessor :array, :max_buffer_size
  
  def initialize(type)
    @array = []
    @data = []
    @max_array_size = 100
    @bpm = 0
    @timer = 0
    @is_a_peak = false
    @peak_count = 0
    @last_peak = 0
    @type = type
  end  
  
  def add(input)
    case @type
    when GEOLOCATION
      lat = input.value1
      long = input.value2
      @array << [lat.to_f, long.to_f]
    when SWEAT
      @array << input.value1.to_f
    when MUSCLETENSION
      @array << input.value1.to_f
    when ACCELEROMETER
      @array << ((input.value1.to_f + input.value2.to_f + input.value3.to_f) / 3) #calculate median, float
    when GYROSCOPE
      @array << [input.value1.to_f, input.value2.to_f, input.value3.to_f]
    when HEARTRATE
      input = ((input.value1.to_f + input.value2.to_f + input.value3.to_f) / 3) #calculate median, float
      # # #### debug
      # # val = (@timer % 35)
      # # if (val == 0 || val == 1)
      # #   input += 200
      # # end
      # # @timer += 1
      # # ####
      # if @array.size > 0
      #   analyse_data
      # end
      @array << input
    else
      # nothing
    end
    while @array.size > @max_array_size
      @array.delete_at(0) #drop first packets until buffer size <= 100
    end
    return @array
    
  end
  
  def size
    return @hr_array.size
  end

  # def dc_component
  #   @hr_array.inject(:+).to_f / @max_array_size
  # end
  
  def get_array
    if @array.size > 0
      return @array.delete_at(0)
    else
      return nil
    end
  end
  
  def detect_peak
    #treshhold
    treshhold = 150.0
    
    #init vars
    diff = 0    
    i = (@array.size - 1) #last element
    if @array[i-1].present?
        diff = @array[i] - @array[i-1]
        if i >= 2
          if (@is_a_peak & (((diff+@data[i-1][1]+@data[i-2][1]) < -treshhold))) #if derivative drops below treshold
            @is_a_peak = false #transition from peak
          elsif (!@is_a_peak & (((diff+@data[i-1][1]+@data[i-2][1]) > treshhold))) # if derivative goes over treshhold
            @is_a_peak = true #transition to peak
            @peak_count += 1 #add 1 peak to counter
            @bpm = (60.0 / @last_peak) #count BPM
            @last_peak = 0 #reset peak timer
          end
        end
        @last_peak += 0.02 # 50Hz, add 20 ms since last peak
      end
      @data << [@array[i], diff, @is_a_peak, @peak_count, @bpm]
      while @data.size > 100
        @data.delete_at(0)
      end
  end
  
  def get_data
    return_value = []
    i=0
    @data.each do |data|
      return_value << [i, data[0], data[1], data[2], data[3], data[4]]
      i += 1
    end
    return return_value
  end  
end