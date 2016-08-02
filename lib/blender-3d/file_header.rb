module Blender3d
  class FileHeader
    attr_accessor :identifier,
                  :version

    attr_reader :pointer_size, :size_code,
                :endianness, :endian_code

    def initialize(file = nil)
      deserialize(file) if file
    end

    def deserialize(file)
      self.identifier = file.read(7)
      self.pointer_size = file.read(1) == '-'.freeze ? 8 : 4
      self.endianness = file.read(1) == 'v'.freeze ? :little : :big
      self.version = file.read(1) + '.'.freeze + file.read(2)
      self
    end

    def pointer_size=(value)
      @pointer_size = value
      @size_code = @pointer_size == 8 ? 'Q'.freeze : 'L'.freeze
    end

    def endianness=(value)
      @endianness = value
      @endian_code = little_endian? ? '<'.freeze : '>'.freeze
    end

    def little_endian?
      @endianness == :little
    end

    def big_endian?
      !little_endian?
    end
  end
end


