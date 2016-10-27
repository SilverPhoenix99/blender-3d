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
      other.is_a?(Pointer) || other.is_a?(Integer) ? to_i <=> other.to_i : 1
    end

    def ==(other)
      (self <=> other) == 0
    end

    def !=(other)
      !(self == other)
    end

    def hash
      @location.hash
    end

    def +(other)
      return Pointer.new(@location + other) if other.is_a?(Integer)
      raise TypeError, "#{other.class} cannot be implicitly converted into an Integer"
    end

    def -(other)
      return Pointer.new(@location - other) if other.is_a?(Integer)
      return @location - other.location if other.is_a?(Pointer)
      raise TypeError, "#{other.class} cannot be implicitly converted into a Pointer"
    end

    alias_method :eql? , :==
    alias_method :to_i , :location
  end
end
