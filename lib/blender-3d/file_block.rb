module Blender3d
  class FileBlock
    include Serializer

    attr_accessor :code, :size, :pointer, :type_index, :count, :data, :type

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      Reader.new(reader, self).read
    end

    def parse_data(model)
      file = StringIO.new(data)
      reader = model.create_reader(file)
      self.data = count.times.map { self.type.read(reader) }
    end

    def to_xml
      REXML::Element.new(self.class.basename).tap do |e|
        e.add_attribute 'code', code
        e.add_attribute 'pointer', pointer.inspect
        e.add_attribute 'size', size.to_s
        e.add_attribute 'type_index', type_index.to_s
        e.add_element data_to_xml
      end
    end

    private def data_to_xml
      content = value_to_xml(@data)
      return content if content.is_a?(REXML::Element)

      REXML::Element.new('data').tap do |e|
        e.add_attribute 'count', count.to_s
        e.add_text content
      end
    end

    class Reader
      def initialize(reader, file_block = FileBlock.new)
        @reader, @file_block = reader, file_block
      end

      def read
        @file_block.code = @reader.read(4).gsub(/\0.*$/, '')
        @file_block.size = @reader.read_uint32
        @file_block.pointer = Pointer.new(@reader.read_pointer)
        @file_block.type_index = @reader.read_uint32
        @file_block.count = @reader.read_uint32
        @file_block.data = @reader.read(@file_block.size)
        read_dna if @file_block.code == 'DNA1'
        @file_block
      end

      private def read_dna
        file = StringIO.new(@file_block.data)
        @reader = @reader.model.create_reader(file)
        @file_block.data = DnaBlock.new(@reader)
      end
    end
  end
end


