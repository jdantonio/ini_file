require 'ini_file/parser'

module IniFile

  class Content

    attr_reader :name

    def empty?
      return @content.empty?
    end

    def [](key)
      if @content[key].is_a? Hash
        return Content.from_hash(key, @content[key])
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
        yield(Content.from_hash(key, value)) if value.is_a? Hash
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
          return Content.from_hash(key, @content[key])
        else
          return @content[key]
        end
      else
        super
      end
    end

    def self.parse(contents)
      content = Content.new
      content.instance_variable_set(:@content, Parser.parse(contents))
      return content
    end

    private

    def initialize(name = nil)
      @name = name
      @content = {}
    end

    def self.from_hash(name, contents)
      content = Content.new(name)
      content.instance_variable_set(:@content, contents)
      return content
    end

  end
end
