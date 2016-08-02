module Blender3d
  class SimpleType
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      @name
    end

    def inspect
      @name
    end

    def read(reader)
      case @name
        when 'char'     then reader.read(1)
        when 'double'   then reader.read_double
        when 'float'    then reader.read_float
        when 'int'      then reader.read_int32
        when 'int64_t'  then reader.read_int64
        when 'long'     then reader.read_int32
        when 'short'    then reader.read_int16
        when 'uchar'    then reader.read_uint8
        when 'uint64_t' then reader.read_uint64
        when 'ulong'    then reader.read_uint32
        when 'ushort'   then reader.read_uint16
        else
          dna = reader.model.dna_block.data
          struct = dna.structures.find { |struct| struct.type == @name }
          return struct.read(reader) if struct
          length = dna.types.find { |name, size| name == @name }&.last
          return reader.read(length) if length
          raise 'type not found'
      end
    end
  end

  class PointerType
    attr_reader :type

    def initialize(type)
      @type = type
    end

    def to_s
      "Pointer(#@type)"
    end

    def inspect
      "#{@type.inspect}*"
    end

    def read(reader)
      Pointer.new(reader.read_pointer)
    end
  end

  class FunctionPointerType
    attr_reader :return_type

    def initialize(return_type)
      @return_type = return_type
    end

    def to_s
      "Function(#@return_type)"
    end

    def inspect
      "#{@return_type.inspect} (*)()"
    end

    def read(reader)
      Pointer.new(reader.read_pointer)
    end
  end

  # equivalent to PointerType<SimpleType<char>> (char*)
  class ZeroDelimitedStringType
    def to_s
      "ZeroDelimitedString"
    end

    def inspect
      'char*'
    end

    def read(reader)
      reader.read_string.chop
    end
  end

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
      reader.read(@length).gsub(/\0+$/, '')
    end
  end

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