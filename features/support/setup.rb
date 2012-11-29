require 'bundler/setup'

require 'ini_file'

require 'aruba/cucumber'
require 'factory_girl'

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), '../factories')
FactoryGirl.find_definitions

Before do

end

After do

end
