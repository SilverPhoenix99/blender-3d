module Blender3d
  class Field
    attr_reader :type, :name

    def initialize(type, name)
      @type, @name = type, name
    end

    def to_s
      "Field[#@name](#@type)"
    end

    def inspect
      "#{@type.inspect} #@name"
    end
  end
end
