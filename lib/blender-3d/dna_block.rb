module Blender3d
  class DnaBlock
    attr_accessor :code, :types, :structures

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      Reader.new(reader, self).read
    end

    class Reader
      def initialize(reader, dna_block = DnaBlock.new)
        @reader, @dna_block = reader, dna_block
      end

      def read
        @dna_block.code = @reader.read(4)
        @names = read_names
        read_types
        read_structures
        @dna_block
      end

      private

        def read_names
          @reader.read(4) # identifier 'NAME'
          count = @reader.read_int32
          count.times.map { @reader.read_string.chop.freeze }
        end

        def read_types
          read_aligned # identifier 'TYPE' 4 byte aligned

          count = @reader.read_int32
          types = count.times.map { @reader.read_string.chop.freeze }

          read_aligned # identifier 'TLEN' 4 byte aligned
          lengths = count.times.map { @reader.read_int16 }

          @dna_block.types = types.zip(lengths)
        end

        def read_aligned
          offset = 4 + (( 4 - (@reader.tell % 4) ) % 4)
          @reader.read(offset)
        end

        def read_structures
          read_aligned # identifier 'STRC' 4 byte aligned
          count = @reader.read_int32
          @dna_block.structures = count.times.map { read_structure }
        end

        def read_structure
          type_index = @reader.read_int16
          num_fields = @reader.read_int16

          fields = num_fields.times.map { read_field }

          StructureDefinition.new(*@dna_block.types[type_index], fields)
        end

        def read_field
          field_type = @dna_block.types[@reader.read_int16][0]
          field_name = @names[@reader.read_int16]
          factory = FieldParserFactory.create_for(field_type, field_name)
          factory.parse
        end
    end
  end
end
