module Blender3d
  # equivalent to ArrayType<SimpleType<char>, length> (char[length])
  class FixedLengthStringType
    attr_reader :length

    def initialize(length)
      @length = length
    end

    def to_s
      "FixedLengthString(#@length)"
    end

    def inspect
      "char[#@length]"
    end

    def read(reader)
      reader.read(@length).gsub(/\0.*$/, '')
    end
  end
end
