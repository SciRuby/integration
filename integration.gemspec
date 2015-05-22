$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'integration/version'

Gem::Specification.new do |s|
  s.name = "integration"
  s.version = Integration::VERSION
  s.authors = ["Claudio Bustos","Ben Gimpert"]
  s.description = "Numerical integration for Ruby, with a simple interface"
  s.email = ["clbustos@gmail.com", "No Email"]
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features,benchmark}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.summary = "A suite for integration in Ruby"

  s.add_runtime_dependency 'text-table', '~> 1.2'

  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'bundler', '~> 1.9'
  s.add_development_dependency 'rspec', '~> 3.2'
end
