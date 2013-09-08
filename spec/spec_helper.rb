$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  project_name 'ini_file'
  add_filter '/doc/'
  add_filter '/pkg/'
  add_filter '/spec/'
end

require 'bundler/setup'

require 'ini_file'

require 'rspec'
require 'fakefs'

RSpec.configure do |config|

  config.before(:suite) do
    FakeFS.activate!
  end

  config.after(:suite) do
    FakeFS.deactivate!
  end
end
