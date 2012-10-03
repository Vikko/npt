class ValueBuffer
  BUFFER = []
  MAX_BUFFER_SIZE = 5
  
  def self.add(input)
    # hash = {input}
    BUFFER << input #hash possible
    while BUFFER.size > MAX_BUFFER_SIZE
      BUFFER.drop(0) #drop first packets until buffer size <= 10
    end 
  end
  
  def self.size
    return BUFFER.size
  end
  
  def self.get
    if BUFFER.size > 0
      return BUFFER.delete(0)
    else
      return nil
    end
  end
    
end