module Blender3d
  class ObjectReader
    attr_reader :file
    attr_accessor :model

    def initialize(file, model = nil)
      @file, @model = file, model
      %w'c s l q'.each.with_index do |code, i|
        bytes = 1 << i
        bits = 8 * bytes
        name = 'int' + bits.to_s
        define_reader name, bytes, code
        define_reader 'u' + name, bytes, code.upcase
      end

      code = @model.header.little_endian? ? 'e' : 'g'
      instance_eval "def read_float; @file.read(4).unpack('#{code}') end"
      instance_eval "def read_double; @file.read(8).unpack('#{code.upcase}') end"

      define_reader 'pointer', @model.header.pointer_size, @model.header.size_code
    end

    private def define_reader(name, num_bytes, unpack_type)
      unpack_type += @model.header.endian_code
      instance_eval "def read_#{name}; @file.read(#{num_bytes}).unpack('#{unpack_type}').first end"
    end

    def read(length)
      @file.read(length)
    end

    def read_string
      @file.gets("\0")
    end

    def seek(position)
      @file.seek(position)
    end

    def tell
      @file.tell
    end
  end
end


