class ValueBuffer
  attr_accessor :array, :max_buffer_size
  
  def initialize
    @array = []
    @max_array_size = 100
  end  
  
  def add(input)
    # hash = {parse(input)}
    @array << input #hash possible
    while @array.size > @max_array_size
      @array.delete_at(0) #drop first packets until buffer size <= 10
    end
    return @array
  end
  
  def size
    return @array.size
  end

  # def dc_component
  #   @array.inject(:+).to_f / @max_array_size
  # end
  
  def get
    if @array.size > 0
      return @array.delete_at(0)
    else
      return nil
    end
  end
  
  def deriv
    #treshhold
    treshhold = 150.0
    
    #init vars
    is_a_peak = false
    peak_count = 0
    deriv = []
    bpm = 0
    last_peak = 0
  
    (1..(@array.size-1)).each do |i|
      if @array[i-1].present?
        diff = @array[i] - @array[i-1]
        if i >= 3
          if (is_a_peak & ((diff+deriv[i-1][0]+deriv[i-2][0]) < -treshhold)) #if derivative drops below treshold
            is_a_peak = false
          end 
          if (!is_a_peak & ((diff+deriv[i-1][0]+deriv[i-2][0]) > treshhold)) # if derivative goes over treshhold
            is_a_peak = true #set peak
            peak_count += 1 #add 1 peak to counter
            bpm = (60.0 / last_peak) #count BPM
            last_peak = 0 #reset peak timer
          end
        end
        last_peak += 0.02 # 50Hz, add 20 ms since last peak
        deriv << [diff, is_a_peak, peak_count, bpm]
      end
      i += 1
    end
    return deriv
  end
  
    
end