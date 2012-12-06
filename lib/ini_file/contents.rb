module IniFile

  IniFormatError = Class.new(StandardError)

  class Contents

    PROPERTY_PATTERN = /^\s*(\w+)\s*[:=]\s*['"]?([^'"]+)['"]?$/

    def initialize(contents)
      raise ArgumentError.new('contents cannot be nil') if contents.nil?
      raise ArgumentError.new('contents must be a string') unless contents.is_a? String
      raise ArgumentError.new('contents cannot be blank') if contents.strip.empty?
      @contents = {}
      parse(contents)
    end

    def [](key)
      return @contents[key]
    end

    private

    def parse(contents)
      contents =~ PROPERTY_PATTERN
      key = $1.downcase.to_sym
      value = $2.gsub(/\s+/, ' ')
      @contents[key] = value
    end

  end

end
