require 'ini_file/parser'

module IniFile

  class Contents

    def initialize(contents)
      @contents = Parser.parse(contents)
    end

    def empty?
      return @contents.empty?
    end

    def [](key)
      if @contents[key].is_a? Hash
        return Section.new(self, key)
      else
        return @contents[key]
      end
    end

    def to_hash
      return Marshal.load( Marshal.dump(@contents) )
    end

    def each(&block)
      @contents.each do |key, value|
        yield(key, value) unless value.is_a? Hash
      end
    end

    def each_section(&block)
      @contents.each do |key, value|
        yield(Section.new(self, key)) if value.is_a? Hash
      end
    end

    def method_missing(method, *args, &block)

      key = method.to_s.downcase.to_sym

      if @contents.has_key?(key)
        if args.count > 0
          raise ArgumentError.new("wrong number of arguments(#{args.count} for 0)")
        elsif block_given?
          raise ArgumentError.new("block syntax not supported")
        elsif @contents[key].is_a? Hash
          return Section.new(self, key)
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
        current = parent.instance_variable_get(:@contents)
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
