module Blender3d
  # equivalent to PointerType<SimpleType<char>> (char*)
  class NullTerminatedStringType
    def to_s
      'NullTerminatedString'
    end

    def inspect
      'char*'
    end

    def read(reader)
      reader.read_string.chop
    end
  end
end
