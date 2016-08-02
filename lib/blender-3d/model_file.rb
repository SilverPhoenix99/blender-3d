module Blender3d
  class ModelFile
    attr_reader :header, :blocks

    def initialize(file = nil)
      @blocks = []
      deserialize(file) if file
    end

    def deserialize(file)
      @header = FileHeader.new(file)
      reader = @header.create_reader(file)
      @blocks.clear

      loop do
        @blocks << FileBlock.new(reader)
        break if reader.tell == reader.file.size
      end

      dna_block = @blocks.find { |block| block.code == 'DNA1' }
      return self unless dna_block

      @blocks.select { |block| block.code != 'DNA1' }.each do |block|
        block.type = dna_block.data.structures[block.type_index]
      end

      self
    end
  end
end


