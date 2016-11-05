module Blender3d
  class ArrayType
    attr_reader :type, :size

    def initialize(type, size)
      @type, @size = type, size
    end

    def dimensions
      @sizes.size
    end

    def to_s
      "Array[#@size](#@type)"
    end

    def inspect
      "#{@type.inspect}[#@size]"
    end

    def read(reader)
      @size.times.map { @type.read(reader) }
    end
  end
end
