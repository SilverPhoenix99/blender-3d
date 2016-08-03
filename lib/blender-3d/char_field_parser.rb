module Blender3d
  class CharFieldParser
    def initialize(name)
      @name = name
    end

    def parse
      type = case @name
        when GenericFieldParser::FUNCTION_POINTER
          FunctionPointerType.new(SimpleType.new(FieldParserFactory::CHAR_TYPE))

        when GenericFieldParser::POINTER_ARRAY
          array_size = $2.to_i
          ArrayType.new(NullTerminatedStringType.new, array_size)

        when GenericFieldParser::MULTI_POINTER
          PointerType.new(NullTerminatedStringType.new)

        when GenericFieldParser::POINTER
          NullTerminatedStringType.new

        when GenericFieldParser::MULTI_ARRAY
          array_size, string_size = $2.to_i, $3.to_i
          ArrayType.new(FixedLengthStringType.new(string_size), array_size)

        when GenericFieldParser::ARRAY
          array_size = $2.to_i
          FixedLengthStringType.new(array_size)

        else
          SimpleType.new(FieldParserFactory::CHAR_TYPE)

      end

      name = $1 || @name
      Field.new(type, name)
    end
  end
end
