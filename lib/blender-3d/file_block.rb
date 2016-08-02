module Blender3d
  class FileBlock
    attr_accessor :code, :size, :pointer, :type_index, :count, :raw_data, :type
    attr_writer :data

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      Reader.new(reader, self).read
    end

    def data
      @data || self.raw_data
    end

    def parse_data(model)
      file = StringIO.new(self.raw_data)
      reader = model.create_reader(file)
      self.data = self.type.read(reader)
    end

    class Reader
      def initialize(reader, file_block = FileBlock.new)
        @reader, @file_block = reader, file_block
      end

      def read
        @file_block.code = @reader.read(4).gsub("\0", '')
        @file_block.size = @reader.read_uint32
        @file_block.pointer = Pointer.new(@reader.read_pointer)
        @file_block.type_index = @reader.read_uint32
        @file_block.count = @reader.read_uint32
        @file_block.raw_data = @reader.read(@file_block.size)
        read_dna if @file_block.code == 'DNA1'
        @file_block
      end

      private def read_dna
        file = StringIO.new(@file_block.raw_data)
        @reader = @reader.model.create_reader(file)
        @file_block.data = DnaBlock.new(@reader)
      end
    end
  end
end


