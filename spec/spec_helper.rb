$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'bundler/setup'

require 'ini_file'

require 'rspec'
require 'factory_girl'

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), '../factories')
FactoryGirl.find_definitions

RSpec.configure do |config|

end
