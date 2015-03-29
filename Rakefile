$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'integration/version'
require 'bundler'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Open an irb session preloaded with integration"
task :console do
  sh "irb -rubygems -I lib -r integration.rb"
end

task :default => :spec
