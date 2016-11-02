require_relative 'lib/blender-3d/version'

Gem::Specification.new do |s|
  s.name          = 'blender-3d'
  s.version       = Blender3d::VERSION
  s.summary       = 'Blender 3d file parser.'
  s.description   = 'Blender 3d file parser.'
  s.license       = 'MIT'
  s.authors       = %w'SilverPhoenix99'
  s.email         = %w'silver.phoenix99@gmail.com'
  s.require_paths = %w'lib'
  s.files         = Dir['{lib/**/*.rb,*.md}']
  s.add_dependency 'facets', '~> 3'
end
