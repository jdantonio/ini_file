module IniFile

  IniFormatError = Class.new(StandardError)

  class Contents

    PROPERTY_PATTERN = /\s*(\w+)\s*[:=]\s*(.+)/
    COMMENT_PATTERN = /([;#].*)/
    #SECTION_PATTERN = /\s*\[\s*(\S+)\s*\]\s*/
    SECTION_PATTERN = /\s*\[(.+)\]\s*/

    def initialize(contents)
      raise ArgumentError.new('contents cannot be nil') if contents.nil?
      raise ArgumentError.new('contents must be a string') unless contents.is_a? String
      raise ArgumentError.new('contents cannot be blank') if contents.strip.empty?
      @contents = {}
      parse(contents)
    end

    def empty?
      return @contents.empty?
    end

    def [](key)
      return @contents[key]
    end

    def to_hash
      return Marshal.load( Marshal.dump(@contents) )
    end

    def method_missing(method, *args, &block)
      #super if args.count > 0
      #super if block

      key = method.to_s.downcase.to_sym

      if @contents.has_key?(key)
        if @contents[key].is_a? Hash
          return Node.new(self, key)
        else
          return @contents[key]
        end
      else
        super
      end

    end

    private

    class Node

      attr_reader :parent
      attr_reader :path

      def initialize(parent, *path)
        @parent = parent
        @path = path.flatten
      end

      def [](key)
        return value[key]
      end

      def value
        current = parent
        path.each { |node| current = current[node] }
        return current
      end

      def method_missing(method, *args, &block)
        key = method.to_s.downcase.to_sym
        if value[key].is_a? Hash
          return Node.new(parent, path, method)
        elsif value[key].nil?
          super
        else
          return value[key]
        end
      end
    end

    def parse(contents)

      pattern = /^#{SECTION_PATTERN}|#{PROPERTY_PATTERN}|#{COMMENT_PATTERN}$/

      current = @contents

      contents.scan(pattern) do |section, key, value, comment|
        if section
          sections = section.split(/[\.\\\/,]/)
          current = @contents
          sections.each do |section|
            section = section.strip.downcase.to_sym
            current[section] = {} unless current.has_key?(section)
            current = current[section]
          end
        elsif key && value
          key = key.downcase.to_sym
          value = $1 if value =~ /^"(.+)"$/
          value = $1 if value =~ /^'(.+)'$/
          value = value.gsub(/\s+/, ' ')
          current[key] = value
        elsif comment
          # do nothing
        else
          # possibly throw exceptions
        end
      end
      @contents.freeze
    end

  end

end
