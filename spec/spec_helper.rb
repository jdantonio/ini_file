$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'bundler/setup'

require 'ini_file'

require 'rspec'
require 'fakefs'

RSpec.configure do |config|

end
