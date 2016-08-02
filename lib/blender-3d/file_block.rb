require 'stringio'

module Blender3d
  class FileBlock
    attr_accessor :code, :size, :pointer, :type_index, :count, :data, :type
    attr_writer :raw_data

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      self.code = reader.read(4).gsub("\0", '')
      self.size = reader.read_uint32
      self.pointer = reader.read_pointer
      self.type_index = reader.read_uint32
      self.count = reader.read_uint32
      self.data = reader.read(self.size)

      if self.code == 'DNA1'
        self.raw_data = self.data
        file = StringIO.new(self.data)
        reader = reader.header.create_reader(file)
        self.data = DnaBlock.new(reader)
      end

      self
    end

    def raw_data
      @raw_data || self.data
    end
  end
end


