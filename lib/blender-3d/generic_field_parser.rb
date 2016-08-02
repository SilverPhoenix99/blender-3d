module Blender3d
  class GenericFieldParser
    FUNCTION_POINTER = /^\(\*([^\)]+)\)\(\)$/
    POINTER_ARRAY    = /^\*([^\[]+)\[(\d+)\]$/
    MULTI_POINTER    = /^\*{2}(.+)$/
    POINTER          = /^\*(.+)$/
    MULTI_ARRAY      = /^([^\[]+)\[(\d+)\]\[(\d+)\]$/
    ARRAY            = /^([^\[]+)\[(\d+)\]$/

    def initialize(type, name)
      @type, @name = type, name
    end

    def parse
      type = case @name
        when FUNCTION_POINTER
          FunctionPointerType.new(@type)

        when POINTER_ARRAY
          array_size = $2.to_i
          ArrayType.new(build_pointer_type, array_size)

        when MULTI_POINTER
          PointerType.new(build_pointer_type)

        when POINTER
          build_pointer_type

        when MULTI_ARRAY
          array1_size, array2_size = $2.to_i, $3.to_i
          ArrayType.new(ArrayType.new(build_simple_type, array2_size), array1_size)

        when ARRAY
          array_size = $2.to_i
          ArrayType.new(build_simple_type, array_size)

        else
          build_simple_type

      end

      name = $1 || @name
      Field.new(type, name)
    end

    private def build_pointer_type
      PointerType.new(build_simple_type)
    end

    private def build_simple_type
      SimpleType.new(@type)
    end
  end
end
