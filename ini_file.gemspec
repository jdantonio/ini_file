# -*- encoding: utf-8 -*-
$:.push File.join(File.dirname(__FILE__), 'lib')

require 'ini_file/version'

Gem::Specification.new do |s|
  s.name        = 'ini_file'
  s.version     = IniFile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jerry D'Antonio"]
  s.email       = ['jerry.dantonio@gmail.com']
  s.homepage    = 'http://www.jerryknowscode.com'
  s.summary     = %q{Manage simple INI files.}
  s.description = %q{'The INI file format is an informal standard for configuration files for some platforms or software. INI files are simple text files with a basic structure composed of 'sections' and 'properties'.' - Wikipedia}

  s.files         = Dir['Rakefile', 'README*', 'LICENSE*']
  s.files        += Dir['{lib,spec,tasks}/**/*']
  s.test_files    = Dir['{spec}/**/*']
  s.require_paths = ['lib', 'lib/ini_file']

  # Production dependencies
  
  s.add_dependency 'bundler'

  s.add_dependency 'i18n'
  s.add_dependency 'activesupport'

  # Development dependencies
  
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'rake'

  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec'
  
  s.add_development_dependency 'fakefs'

end
