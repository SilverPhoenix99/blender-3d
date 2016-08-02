require_relative 'blender-3d/version'
require_relative 'blender-3d/object_reader'
require_relative 'blender-3d/file_header'
require_relative 'blender-3d/file_block'
require_relative 'blender-3d/dna_block'
require_relative 'blender-3d/model_file'

=begin

Usage:

require 'blender-3d'

file = File.open('cube.blend', 'rb')
model = Blender3d::ModelFile.new(file);

dna = model.blocks.find { |b| b.code == 'DNA1' };

=end