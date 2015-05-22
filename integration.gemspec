$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'integration/version'

Gem::Specification.new do |s|
  s.name = 'integration'
  s.version = Integration::VERSION

  s.authors = ['Claudio Bustos', 'Ben Gimpert']
  s.email = ['clbustos@gmail.com']
  s.homepage = 'http://sciruby.com'

  s.summary = 'Numerical integration for Ruby with a simple interface.'
  s.description = 'Numerical integration for Ruby with a simple interface.'
  s.license = 'See README.md.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,benchmark}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'text-table', '~> 1.2'

  s.add_development_dependency 'bundler', '>= 1.3.0', '< 2.0'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'rspec', '~> 3.2'
end
