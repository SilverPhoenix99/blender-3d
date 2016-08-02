module Blender3d
  class ObjectReader
    attr_reader :file
    attr_accessor :header

    def initialize(file, header = nil)
      @file, @header = file, header
      %w'c s l q'.each.with_index do |code, i|
        bytes = 1 << i
        bits = 8 * bytes
        name = 'int' + bits.to_s
        define_reader name, bytes, code
        define_reader 'u' + name, bytes, code.upcase
      end

      define_reader 'pointer', @header.pointer_size, @header.size_code

      code = @header.little_endian? ? 'e' : 'g'
      instance_eval "def read_float; @file.read(4).unpack('#{code}') end"
    end

    private def define_reader(name, num_bytes, unpack_type)
      instance_eval "def read_#{name}; @file.read(#{num_bytes}).unpack('#{unpack_type + @header.endian_code}').first end"
    end

    def read(length)
      @file.read(length)
    end

    def seek(position)
      @file.seek(position)
    end

    def tell
      @file.tell
    end

    def read_string
      @file.gets("\0")
    end
  end
end


