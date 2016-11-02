module Blender3d
  module Serializer
    private def value_to_xml(val)
      case val
        when Pointer then REXML::Text.new(val.inspect, true)
        when Array then array_to_xml(val)
        else val.respond_to?(:to_xml) ? val.to_xml : REXML::Text.new(val.to_s, true)
      end
    end

    private def array_to_xml(ary)
      REXML::Element.new('data').tap do |e|
        e.add_attribute 'count', ary.count.to_s
        ary.each do |value|
          value = value_to_xml(value)
          value = REXML::Element.new('data-element').tap { |x| x << value } if value.is_a?(REXML::Text)
          e << value
        end
      end
    end
  end
end