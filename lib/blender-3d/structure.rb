module Blender3d
  class Structure
    class << self
      attr_reader :definition
    end

    def initialize(reader = nil)
      deserialize(reader) if reader
    end

    def deserialize(reader)
      self.class.definition.fields.each do |field|
        value = field.type.read(reader)
        instance_variable_set "@#{field.name}", value
      end
      self
    end
  end
end
