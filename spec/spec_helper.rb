$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'bundler/setup'

require 'ini_file'

require 'rspec'

RSpec.configure do |config|

end
