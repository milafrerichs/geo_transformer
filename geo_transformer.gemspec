Gem::Specification.new do |s|
  s.name        = 'geo_transformer'
  s.version     = '0.0.1'
  s.date        = '2015-02-22'
  s.summary     = "Geo Transformer"
  s.description = "Transform Geo objects"
  s.authors     = ["Mila Frerichs"]
  s.email       = 'mila.frerichs@civicvision.de'
  s.files       = ["Gemfile","lib/geo_transformer.rb"]
  s.require_paths = ["lib"]
  s.homepage    =
    'http://rubygems.org/gems/geo_transformer'
  s.license       = 'MIT'
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
