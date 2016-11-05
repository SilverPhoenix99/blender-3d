module Blender3d
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
      pointer = Pointer.new(reader.read_pointer)

      model = reader.model
      block = model.pointers[pointer]
      if block && block.data.is_a?(String) && !block.type
        block.type = get_type(block, model)
        block.parse_data(reader.model)
      end

      pointer
    end

    private

    def get_type(block, model)
      return @type if block.count > 1
      size = get_size(model)
      return @type unless size > 0 && block.size > size && block.size % size == 0
      ArrayType.new(@type, block.size / size)
    end

    def get_size(model)
      if @type.is_a?(PointerType)
        model.header.pointer_size
      else
        model.dna_block.data.types.find { |type, _| type == @type.name }.last
      end
    end
  end
end
