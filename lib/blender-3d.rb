require 'stringio'

require_relative 'blender-3d/version'
require_relative 'blender-3d/object_reader'

require_relative 'blender-3d/pointer'
require_relative 'blender-3d/types'
require_relative 'blender-3d/field'
require_relative 'blender-3d/char_field_parser'
require_relative 'blender-3d/generic_field_parser'
require_relative 'blender-3d/field_parser_factory'

require_relative 'blender-3d/structure'
require_relative 'blender-3d/structure_definition'

require_relative 'blender-3d/file_header'
require_relative 'blender-3d/file_block'
require_relative 'blender-3d/dna_block'
require_relative 'blender-3d/model'


=begin

Usage:

require 'blender-3d'
# require_relative 'blender-3d'

model = Blender3d::Model.from_file('cube.blend');

=end