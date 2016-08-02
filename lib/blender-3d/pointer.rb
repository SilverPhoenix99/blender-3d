module Blender3d
  class Pointer
    attr_reader :location

    def initialize(location)
      @location = location
    end

    def to_s
      "Pointer(#{inspect})"
    end

    def inspect
      return '0x0' if @location == 0
      return '0x%08x' % @location if @location < (1 << 32)
      '0x%016x' % @location
    end

    def <=>(other)
      other.is_a?(Pointer) ? location <=> other.location : 1
    end

    def ==(other)
      (self <=> other) == 0
    end
  end
end
