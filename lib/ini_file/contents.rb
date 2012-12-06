module IniFile

  IniFormatError = Class.new(StandardError)

  class Contents

    def initialize(contents)
      raise ArgumentError.new('contents cannot be nil') if contents.nil?
      raise ArgumentError.new('contents must be a string') unless contents.is_a? String
      raise ArgumentError.new('contents cannot be blank') if contents.strip.empty?
      parse(contents)
    end

    def [](key)
    end

    private

    def parse(contents)
    end

  end

end
