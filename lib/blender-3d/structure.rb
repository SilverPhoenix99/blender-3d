module Blender3d
  class Structure
    class << self
      attr_reader :definition
    end

    include Serializer

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

    def to_xml
      vars = instance_variables.map do |n|
        value = instance_variable_get(n)
        REXML::Element.new(n[1..-1]).tap { |e| e << value_to_xml(value) }
      end

      REXML::Element.new(self.class.basename).tap do |e|
        vars.each { |v| e.add_element v }
      end
    end
  end
end
