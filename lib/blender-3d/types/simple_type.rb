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
          name = @name[0].upcase + @name[1..-1]
          struct = dna.structures.find { |struct| struct.name == name }
          return struct.read(reader) if struct
          length = dna.types.find { |name, _size| name == @name }&.last
          return reader.read(length) if length
          raise 'type not found'
      end
    end
  end
end
