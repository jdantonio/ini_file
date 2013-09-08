$LOAD_PATH << File.expand_path("../lib", __FILE__)

require 'ini_file/version'
require 'date'
require 'rbconfig'

Gem::Specification.new do |s|
  s.name        = 'ini_file'
  s.version     = IniFile::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jerry D'Antonio"]
  s.email       = ['jerry.dantonio@gmail.com']
  s.homepage    = 'https://github.com/jdantonio/ini_file'
  s.summary     = %q{Manage simple INI files.}
  s.license     = 'MIT'
  s.date        = Date.today.to_s

  s.description = <<-EOF
    The INI file format is an informal standard for configuration files
    for some platforms or software. INI files are simple text files with
    a basic structure composed of 'sections' and 'properties'.' - Wikipedia
  EOF

  s.files         = Dir['README*', 'LICENSE*']
  s.files        += Dir['{lib,spec}/**/*']
  s.test_files    = Dir['{spec}/**/*']
  s.extra_rdoc_files = Dir['README*', 'LICENSE*']
  s.require_paths = ['lib', 'lib/ini_file']

  s.required_ruby_version = '>= 1.9.2'

  s.post_install_message = <<-EOF
    Alright you primitive screwheads, listen up. See this? This is my boomstick!'
  EOF

  s.add_development_dependency 'bundler'
end
