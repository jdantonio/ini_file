$:.push File.join(File.dirname(__FILE__))

require "ini_file/contents"
require "ini_file/parser"
require "ini_file/version"

module IniFile
  extend self

  def load(path)
    #contents = File.open(path, 'r') {|f| f.read }
    file = File.open(path, 'r')
    contents = file.read
    file.close
    return Contents.new(contents)
  end

end
