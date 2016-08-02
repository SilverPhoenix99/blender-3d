module Blender3d
  module FieldParserFactory
    CHAR_TYPE = 'char'.freeze

    def self.create_for(type, name)
      return CharFieldParser.new(name) if type == CHAR_TYPE
      GenericFieldParser.new(type, name)
    end
  end
end
