module Blender3d
  class StructureDefinition
    attr_reader :type, :size, :fields

    def initialize(type, size, fields = [])
      @type, @size, @fields = type, size, fields
    end

    def read(reader)
      fields.reduce({}) { |h, field| h[field.name] = field.type.read(reader); h }
    end
  end
end
