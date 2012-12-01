$:.push File.join(File.dirname(__FILE__))

require "ini_file/contents"
require "ini_file/version"

module IniFile
  extend self

  def load(path)
    #contents = File.open(path, 'r').read
    #file.close
  end

end
