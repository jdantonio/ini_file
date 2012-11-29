# -*- encoding: utf-8 -*-
$:.push File.join(File.dirname(__FILE__), 'lib')

require "ini_file/version"

Gem::Specification.new do |s|
  s.name        = "ini_file"
  s.version     = IniFile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jerry D'Antonio"]
  s.email       = ["jerry.dantonio@gmail.com"]
  s.homepage    = "http://www.jerryknowscode.com"
  s.summary     = %q{Gem project generator.}
  s.description = %q{Sample project setup for creating a Rubygem, with a project generator.}

  s.files         = Dir['Rakefile', 'README*', 'LICENSE*']
  s.files        += Dir['{bin,factories,features,lib,spec,tasks}/**/*']
  s.test_files    = Dir['{spec,features}/**/*']
  s.bindir        = 'bin'
  s.executables   = Dir.glob('bin/*').map { |f| File.basename(f) }
  s.require_paths = ['lib', 'lib/ini_file']

  s.default_executable = "ini_file"

  # Production dependencies
  
  s.add_dependency "bundler"

  s.add_dependency "i18n"
  s.add_dependency "activesupport"
  s.add_dependency "thor"

  # Development dependencies
  
  s.add_development_dependency "rake"

  s.add_development_dependency "simplecov"
  s.add_development_dependency "rspec"

  s.add_development_dependency "cucumber"
  s.add_development_dependency "aruba"

  s.add_development_dependency "factory_girl"
  s.add_development_dependency "faker"

end
