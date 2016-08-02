module Blender3d
  class DnaBlock
    attr_accessor :code, :types, :structures

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      self.code = reader.read(4)

      reader.read(4) # identifier 'NAME'
      count = reader.read_int32
      names = count.times.map { reader.read_string.chop.freeze }

      offset = 4 + (( 4 - (reader.tell % 4) ) % 4)
      reader.read(offset) # identifier 'TYPE' 4 byte aligned

      count = reader.read_int32
      types = count.times.map { reader.read_string.chop.freeze }

      offset = 4 + (( 4 - (reader.tell % 4) ) % 4)
      reader.read(offset) # identifier 'TLEN' 4 byte aligned
      lengths = count.times.map { reader.read_int16 }

      types = types.zip(lengths)

      offset = 4 + (( 4 - (reader.tell % 4) ) % 4)
      reader.read(offset) # identifier 'STRC' 4 byte aligned

      count = reader.read_int32

      self.structures = count.times.map do
        type_index = reader.read_int16
        num_fields = reader.read_int16

        fields = num_fields.times.map do
          field_type = types[reader.read_int16][0]
          field_name = names[reader.read_int16]
          [field_type, field_name]
        end

        types[type_index] << fields
      end

      self.types = types

      self
    end
  end
end


