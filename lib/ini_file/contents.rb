module IniFile

  IniFormatError = Class.new(StandardError)

  class Contents

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

      key = method.to_s.downcase.to_sym

      if @contents.has_key?(key)
        if args.count > 0
          raise ArgumentError.new("wrong number of arguments(#{args.count} for 0)")
        elsif block_given?
          raise ArgumentError.new("block syntax not supported")
        elsif @contents[key].is_a? Hash
          return Node.new(self, key)
        else
          return @contents[key]
        end
      else
        super
      end

    end

    private

    # :nodoc:
    #
    # Helper class for iterating contents using dynamic methods
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

      section_pattern = /^\s*\[([^\]]+)\]\s*$/
      property_pattern = /^\s*(.+)\s*[:=](.*)$/
      #property_pattern = /^\s*([^:=\r\n]+)\s*[:=]([^\r\n]*)$/
      comment_pattern = /^\s*([;#].*)$/

      pattern = /#{section_pattern}|#{property_pattern}|#{comment_pattern}|^(.*)$/

      current = @contents

      contents.scan(pattern) do |section, key, value, comment, garbage|

        if section
          if section.scan(/[\.\\\/,]/).uniq.size > 1
            raise IniFormatError.new("Section hierarchy names must use one delimiter: #{section}")
          end
          sections = section.split(/[\.\\\/,]/)
          current = @contents

          sections.each do |section|
            section = section.strip.downcase.to_sym
            if section.empty?
              raise IniFormatError.new("Section names cannot be blank: #{section}")
            elsif section =~ /[\W\s]+/
              raise IniFormatError.new("Section names cannot contain spaces or punctuation: #{section}")
            elsif current.has_key?(section) && !current[section].is_a?(Hash)
              raise IniFormatError.new("Section name matches existing property name: #{section}")
            else
              current[section] = {} unless current.has_key?(section)
              current = current[section]
            end
          end

        elsif key && value
          key = key.strip.downcase.to_sym
          value = value.strip
          if key.empty?
            raise IniFormatError.new("Property names cannot be blank: #{key}")
          elsif current[key]
            raise IniFormatError.new("Duplicate keys are not allowed: #{key}")
          elsif key =~ /[\W\s]+/
            raise IniFormatError.new("Property names cannot contain spaces or punctuation: #{key}")
          end
          value = value.gsub(/\s+/, ' ') unless value =~ /^"(.+)"$|^'(.+)'$/
          if value =~ /^\d+$/
            value = value.to_i
          elsif value =~ /^\d*\.\d+$/
            value = value.to_f
          else
            if value =~ /^"(.+)"$|^'(.+)'$/
              value = $1 || $2
            else
              value = value.gsub(/\s*[^\\]{1}[#;].*$/, '')
              value = value.gsub(/\\([#;])/, '\1')
            end
            value = value.gsub(/\\[0abtrn\\]/) {|s| eval('"%s"' % "#{s}") }
            value = value.gsub(/\\[ux](\d{4})/) {|s| eval('"%s"' % "\\u#{$1}") }
          end
          current[key] = value

        elsif comment
          # do nothing
        elsif garbage
          raise IniFormatError.new("Unrecognized pattern: #{garbage}")
        else
          # possibly throw exceptions?
        end
      end

      @contents.freeze
    end

  end

end
