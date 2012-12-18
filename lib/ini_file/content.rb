require 'ini_file/parser'

module IniFile

  class Content

    def initialize(contents)
      @content = Parser.parse(contents)
    end

    def empty?
      return @content.empty?
    end

    def [](key)
      if @content[key].is_a? Hash
        return Section.new(self, key)
      else
        return @content[key]
      end
    end

    def to_hash
      return Marshal.load( Marshal.dump(@content) )
    end

    def each(&block)
      @content.each do |key, value|
        yield(key, value) unless value.is_a? Hash
      end
    end

    def each_section(&block)
      @content.each do |key, value|
        yield(Section.new(self, key)) if value.is_a? Hash
      end
    end

    def method_missing(method, *args, &block)

      key = method.to_s.downcase.to_sym

      if @content.has_key?(key)
        if args.count > 0
          raise ArgumentError.new("wrong number of arguments(#{args.count} for 0)")
        elsif block_given?
          raise ArgumentError.new("block syntax not supported")
        elsif @content[key].is_a? Hash
          return Section.new(self, key)
        else
          return @content[key]
        end
      else
        super
      end

    end

    private

    # :nodoc:
    #
    # Helper class for iterating contents using dynamic methods
    class Section

      attr_reader :parent
      attr_reader :path

      def initialize(parent, *path)
        @parent = parent
        @path = path.flatten
      end

      def name
        @path.first
      end

      def [](key)
        current = value[key]
        if current.is_a? Hash
          return Section.new(parent, path, key)
        else
          return current
        end
      end

      def value
        current = parent.instance_variable_get(:@content)
        path.each { |node| current = current[node] }
        return current
      end

      def each(&block)
        value.each do |key, val|
          yield(key, val) unless val.is_a? Hash
        end
      end

      def each_section(&block)
        value.each do |key, val|
          yield(Section.new(self, key)) if val.is_a? Hash
        end
      end

      def method_missing(method, *args, &block)
        key = method.to_s.downcase.to_sym
        if value[key].is_a? Hash
          return Section.new(parent, path, method)
        elsif value[key].nil?
          super
        else
          return value[key]
        end
      end
    end
  end
end
