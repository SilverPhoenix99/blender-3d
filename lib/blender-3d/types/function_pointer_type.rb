module Blender3d
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
end
