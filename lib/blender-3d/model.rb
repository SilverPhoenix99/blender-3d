module Blender3d
  class Model
    attr_reader :header, :blocks, :pointers

    def self.from_file(path)
      File.open(path, 'rb') { |file| new(file) }
    end

    def initialize(file = nil)
      @blocks = []
      deserialize(file) if file
    end

    def deserialize(file)
      @header = FileHeader.new(file)
      reader = create_reader(file)
      @blocks.clear

      loop do
        @blocks << FileBlock.new(reader)
        break if reader.tell == reader.file.size
      end

      dna_block = self.dna_block
      return self unless dna_block

      render_block = @blocks.find { |b| b.code == 'REND' }
      if render_block
        render_block.type_index = dna_block.data.structures.size
        dna_block.data.structures << render_info
      end

      @blocks.select { |block| block.type_index != 0 }.each do |block|
        block.type = dna_block.data.structures[block.type_index]
        block.parse_data(self)
      end

      @pointers = {}
      @blocks.each { |block| @pointers[block.pointer] = block.data }

      self
    end

    def dna_block
      @blocks.find { |block| block.code == 'DNA1' }
    end

    def create_reader(file)
      ObjectReader.new(file, self)
    end

    def render_info
      @render_info ||= begin
        sizeof_int = dna_block.data.types.find { |name, _| name == 'int' }.last
        struct_size = 2 * sizeof_int + 64
        StructureDefinition.new('RenderInfo', struct_size, [
          Field.new(SimpleType.new('int'), 'sfra'),
          Field.new(SimpleType.new('int'), 'efra'),
          Field.new(FixedLengthStringType.new(64), 'scene_name'),
        ])
      end
    end
  end
end
