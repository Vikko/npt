class ValueBuffer
  attr_accessor :array, :max_buffer_size
  
  def initialize
    @array = []
    @max_array_size = 5
  end  
  
  def self.add(input)
    # hash = {input}
    @array << input #hash possible
    while @array.size > @max_array_size
      @array.delete_at(0) #drop first packets until buffer size <= 10
    end
    return @array
  end
  
  def self.size
    return @array.size
  end
  
  def self.get
    if @array.size > 0
      return @array.delete_at(0)
    else
      return nil
    end
  end
    
end