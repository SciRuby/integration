$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'integration'
require 'rspec'

begin
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_group 'Libraries', 'lib'
  end
rescue LoadError
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
