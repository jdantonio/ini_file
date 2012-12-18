$:.push File.join(File.dirname(__FILE__))

require "ini_file/content"
require "ini_file/parser"
require "ini_file/version"

# http://en.wikipedia.org/wiki/INI_file

module IniFile
  extend self

  def load(path, safe = false)
    contents = File.open(File.expand_path(path), 'r') {|f| f.read }
    return Content.new(contents)
  rescue
    if safe
      return nil
    else
      raise $!
    end
  end

  def parse(contents, safe = false)
    return Parser.parse(contents)
  rescue
    if safe
      return nil
    else
      raise $!
    end
  end
end
