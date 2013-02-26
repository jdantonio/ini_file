#!/bin/bash --login

rvm use ruby-1.9.2-p320@ini_file --create
gem install bundler &>/dev/null 
bundle install &>/dev/null
rake spec

rvm use ruby-1.9.3-p327@ini_file --create
gem install bundler &>/dev/null 
bundle install &>/dev/null
rake spec

rvm use ruby-2.0.0-p0@ini_file --create
gem install bundler &>/dev/null 
bundle install &>/dev/null
rake spec

rvm use jruby-1.7.0@ini_file --create
gem install bundler &>/dev/null 
bundle install &>/dev/null
rake spec
