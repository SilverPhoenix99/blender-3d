module Blender3d
  class StructureDefinition
    attr_reader :name, :size, :fields

    def initialize(name, size, fields = [])
      name = name[0].upcase + name[1..-1]
      @name, @size, @fields = name, size, fields
    end

    def read(reader)
      structure_class.new(reader)
    end

    def structure_class
      Blender3d.const_defined?(name, false) ? Blender3d.const_get(name, false) : define_structure_class
    end

    private

      def define_structure_class
        fields = self.fields
        struct_class = Class.new(Structure) { attr_accessor(*fields.map(&:name)) }
        struct_class.instance_variable_set :@definition, self
        Blender3d.const_set(name, struct_class)
      end
  end
end
