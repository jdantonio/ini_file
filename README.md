# INI File
[![Build Status](https://secure.travis-ci.org/jdantonio/ini_file.png)](http://travis-ci.org/jdantonio/ini_file?branch=master) [![Coverage Status](https://coveralls.io/repos/jdantonio/ini_file/badge.png?branch=master)](https://coveralls.io/r/jdantonio/ini_file?branch=master) [![Dependency Status](https://gemnasium.com/jdantonio/ini_file.png)](https://gemnasium.com/jdantonio/ini_file)

A simple gem for reading INI files. Originally written because I wanted to read
my Git config file in Ruby programs. Now supports virtually all features described
in the [Wikipedia page](http://en.wikipedia.org/wiki/INI_file). Key/value pairs
can be accessed from the +IniFile+ object using both hash syntax and attribute
reader syntax.

The project is hosted on the following sites:

* [RubyGems project page](https://rubygems.org/gems/ini_file)
* [Source code on GitHub](https://github.com/jdantonio/ini_file)
* [YARD documentation on RubyDoc.org](http://rubydoc.info/github/jdantonio/ini_file/)
* [Continuous integration on Travis-CI](https://travis-ci.org/jdantonio/ini_file)
* [Dependency tracking on Gemnasium](https://gemnasium.com/jdantonio/ini_file)
* [Follow me on Twitter](https://twitter.com/jerrydantonio)

## Supported Ruby Versions

* ruby-1.9.2
* ruby-1.9.3
* ruby-2.0.0
* jruby-1.7.0

## Installation

Install from RubyGems:

    gem install ini_file

or add the following line to Gemfile:

    gem 'ini_file'

and run *bundle install* from your shell.

## Usage

Require INI File within your Ruby project:

    require 'ini_file'

then use it:

    ini = IniFile.load('~/.gitconfig')

    ini[:user][:name] #=> "Jerry D'Antonio"
    ini.user.name #=> "Jerry D'Antonio"

    ini[:user].empty? #=> false
    ini.user.empty? #=> false

    ini.color.each do |key, value|
      puts "#{key} is set to #{value}"
    end
    #=> branch is set to auto
    #=> diff is set to auto
    #=> interactive is set to auto
    #=> status is set to auto

    ini.each_section do |section|
      puts section.__name__
    end
    #=> user
    #=> alias
    #=> color
    #=> core
    #=> giggle

    ini[:core].to_hash #=> {:editor=>"vim", :excludesfile=>"~/.gitignore"}
    ini.core.to_hash #=> {:editor=>"vim", :excludesfile=>"~/.gitignore"}

    ini.to_hash #=> {:user=>{:name=>"Jerry D'Antonio", ...

## Copyright

Copyright &copy; 2013 [Jerry D'Antonio](https://twitter.com/jerrydantonio).
It is free software and may be redistributed under the terms specified in
the LICENSE file.

## License

Released under the MIT license.

http://www.opensource.org/licenses/mit-license.php  

> Permission is hereby granted, free of charge, to any person obtaining a copy  
> of this software and associated documentation files (the "Software"), to deal  
> in the Software without restriction, including without limitation the rights  
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
> copies of the Software, and to permit persons to whom the Software is  
> furnished to do so, subject to the following conditions:  
> 
> The above copyright notice and this permission notice shall be included in  
> all copies or substantial portions of the Software.  
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  
> THE SOFTWARE.
