require 'spec_helper'

# http://en.wikipedia.org/wiki/INI_file

module IniFile

  describe Contents do

    context '#new' do

      context 'parameters' do

        let(:contents) { "; this is a comment" }

        it 'requires the first argument to be a string' do
          lambda { Contents.new(contents) }.should_not raise_error
        end

        it 'throws an exception if the first argument is nil' do
          lambda { Contents.new(nil) }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is an empty string' do
          lambda { Contents.new('') }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is nothing but whitespace' do
          lambda { Contents.new('    ') }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is not a string' do
          lambda { Contents.new(123) }.should raise_error(ArgumentError)
        end

      end

      context 'parsing' do

        context 'properties' do

          it 'extracts the key from the left of the delimiter' do
            subject = Contents.new('key=value')
            subject[:key].should_not be_nil
          end

          it 'ignores whitespace before the key' do
            subject = Contents.new('    key=value')
            subject[:key].should eq 'value'
          end

          it 'throws an exception on spaces within the key' do
            pending
            lambda {
              Contents.new('this is the key=value')
            }.should_raise(IniFormatError)
          end

          it 'throws an exception for a duplicate key' do
            pending
            lambda {
              Contents.new("key=value1\nkey=value2")
            }.should_raise(IniFormatError)
          end

          it 'ignores the case of the key' do
            subject = Contents.new('KEY=value')
            subject[:key].should eq 'value'
          end

          it 'allows an equal sign as the delimiter' do
            subject = Contents.new('key=value')
            subject[:key].should eq 'value'
          end

          it 'allows a colon as the delimiter' do
            subject = Contents.new('key:value')
            subject[:key].should eq 'value'
          end

          it 'allows spaces before the delimiter' do
            subject = Contents.new('key  =value')
            subject[:key].should eq 'value'
          end

          it 'allows spaces after the delimiter' do
            subject = Contents.new('key:   value')
            subject[:key].should eq 'value'
          end

          it 'ignores single quotes around the value' do
            pending
            subject = Contents.new("key='value'")
            subject[:key].should eq 'value'
          end

          it 'ignores double quotes around the value' do
            pending
            subject = Contents.new('key="value"')
            subject[:key].should eq 'value'
          end

          it 'allows spaces within the value' do
            subject = Contents.new('key=this is the value')
            subject[:key].should eq 'this is the value'
          end

          it 'collapses concurrent space characters within the value into one' do
            subject = Contents.new("key=this   is\tthe    value")
            subject[:key].should eq 'this is the value'
          end

          it 'preserves the case of the value' do
            subject = Contents.new('key=This is the VALUE')
            subject[:key].should eq 'This is the VALUE'
          end

          it 'allows line continuation when a line ends with a backslash' do
            pending
            subject = Contents.new("key=this\\\nvalue")
            subject[:key].should eq 'this value'
          end

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

          it 'ignores lines beginning with a semicolon' do
            subject = Contents.new(';this is a comment')
            subject.should be_empty
          end

          it 'ignores lines beginning with a number sign' do
            subject = Contents.new('#this is a comment')
            subject.should be_empty
          end

          it 'ignores blank lines' do
            pending
            subject = Contents.new("   \t   ")
            subject.should be_empty
          end

          it 'ignores empty lines' do
            pending
            subject = Contents.new('')
            subject.should be_empty
          end

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

        context 'multiple lines' do

          it 'supports multiple property lines' do
            subject = Contents.new("key1=value1\nkey2=value2")
            subject[:key1].should eq 'value1'
            subject[:key2].should eq 'value2'
          end

          it 'supports multiple comment lines' do
            subject = Contents.new(";this is a comment\n#this is also a comment")
            subject.should be_empty
          end

          it 'supports multiple blank lines' do
            pending
            subject = Contents.new("    \n\n\t")
            subject.should be_empty
          end

        end

      end

    end

    context 'attribute reader' do

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

end
