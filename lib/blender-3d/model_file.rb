module Blender3d
  class ModelFile
    attr_reader :header, :blocks

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

      @blocks.select { |block| block.type_index != 0 }.each do |block|
        block.type = dna_block.data.structures[block.type_index]
        block.parse_data(self)
      end

      self
    end

    def dna_block
      @blocks.find { |block| block.code == 'DNA1' }
    end

    def create_reader(file)
      ObjectReader.new(file, self)
    end
  end
end
