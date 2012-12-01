require 'spec_helper'

# http://en.wikipedia.org/wiki/INI_file

describe IniFile do

  subject { IniFile }

  let(:filename) { 'test.ini' }

  let(:contents) do
<<-INI
; this is a comment
INI
  end

  context 'load class method' do

    context 'file open' do

      it 'throws an exception if the file does not exist' do
        lambda { subject.load(filename) }.should raise_error
      end

      it 'throws an exception on inadequate file permissions'

    end

    context 'parsing' do

      before(:each) do
        subject.load(filename)
      end

      context 'properties' do

        it 'extracts the key from the left of the delimiter'

        it 'ignores whitespace before the key'

        it 'throws an exception on spaces within the key'

        it 'throws an exception for a duplicate key'

        it 'ignores the case of the key'

        it 'allows an equal sign as the delimiter'

        it 'allows a colon as the delimiter'

        it 'allows spaces before the delimiter'

        it 'allows spaces after the delimiter'

        it 'ignores single quotes around the value'

        it 'ignores double quotes around the value'

        it 'allows spaces within the value'

        it 'collapses concurrent space characters within the value into one'

        it 'preserves the case of the value'

        it 'allows line continuation when a line ends with a backslash'

      end

      context 'escape sequences' do

        it 'converts \\\\ into \\'

        it 'converts \\0 into a null character'

        it 'converts \\a into a bell/alert'

        it 'converts \\b into a bell/alert'

        it 'converts \\t into a tab'

        it 'converts \\r into carriage return'

        it 'converts \\n into a newline'

        it 'converts \\; into a semicolon'

        it 'converts \\# into a number sign'

        it 'converts \\= into an equal sign'

        it 'converts \\: into a colon'

        it 'converts \\x???? into a hexidecimal character'

      end

      context 'comments' do

        it 'ignores lines beginning with a semicolon'

        it 'ignores lines beginning with a number sign'

        it 'ignores blank lines'

      end

      context 'sections' do

        it 'assigns properties before any section headers to the global section'

        it 'assigns properties after a section header to that section'

        it 'requires section headers to be enclosed in square brackets'

        it 'allows whitespace before the opening bracket'

        it 'ignores whitespace between the opening bracket and the header name'

        it 'ignores whitespace between the closing bracket and the header name'

        it 'throws an exception on spaces within the section name'

        it 'throws an exception for a duplicate section name'

        it 'throws an exception when a section name is the same as a property key'

        it 'ignores the case of the section name'

        it 'creates a hierarchy when a section name is delimited by a dot'

        it 'creates a hierarchy when a section name is delimited by a backslash'

        it 'creates a hierarchy when a section name is delimited by a forward slash'

        it 'creates a hierarchy when a section name is delimited by a comma'

        it 'throws an exception when a section name mixes hierarchy delimiters'

      end

    end

  end

  context 'attribute readers' do

    it 'converts global property keys to attributes at the root'
    
    it 'converts global property values to string values at the root'

    it 'converts section names to attributes at the root'

    it 'converts sections to nested attributes under the root'

    it 'converts section property keys to attributes under the section'

    it 'converts section property values to string values under the section'

    it 'converts section hierarchies to nested section hierarchies'

    it 'ignores case of section names'

    it 'ignores case of section hierarchies'

  end

  context '#[]' do

    it 'converts global property keys to symbols at the root'
    
    it 'converts global property values to string values at the root'

    it 'converts section names to symbols at the root'

    it 'converts sections to hash values at the root'

    it 'converts section property keys to symbols in the section hash'

    it 'converts section property values to string values in the section hash'

    it 'converts section hierarchies to hash hierarchies'

  end

  context '#to_hash' do

    it 'converts global property keys to symbols at the root'
    
    it 'converts global property values to string values at the root'

    it 'converts section names to symbols at the root'

    it 'converts sections to hash values at the root'

    it 'converts section property keys to symbols in the section hash'

    it 'converts section property values to string values in the section hash'

    it 'converts section hierarchies to hash hierarchies'

  end

end
