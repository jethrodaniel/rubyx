module Virtual

  # Slots in the Frame a re represented by instances of FrameSlot

  # Slots in the Frame are local or temporary variables in a message
  class FrameSlot < Slot
    def initialize index , type , value = nil
      super(type, value)
      @index = index
    end
    attr_reader :index

    def to_s
      "#{self.class.name}.new(#{index} , #{type}, #{value})"
    end

    def object_name
      return :frame
    end
  end

end
