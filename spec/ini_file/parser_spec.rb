require 'spec_helper'

# http://en.wikipedia.org/wiki/INI_file

module IniFile

  describe Parser do

    context '#parse' do

      context 'method call' do

        let(:contents) { "; this is a comment" }

        it 'requires the first argument to be a string' do
          lambda { subject.parse(contents) }.should_not raise_error
        end

        it 'throws an exception if the first argument is nil' do
          lambda { subject.parse(nil) }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is an empty string' do
          lambda { subject.parse('') }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is nothing but whitespace' do
          lambda { subject.parse('    ') }.should raise_error(ArgumentError)
        end

        it 'throws an exception if the first argument is not a string' do
          lambda { subject.parse(123) }.should raise_error(ArgumentError)
        end

      end

      context 'return value' do

        it 'is a hash on success' do
          subject.parse('key=value').should be_a Hash
        end

        it 'is an empty hash when the content is only comments' do
          subject.parse('; this is a comment').should be_empty
        end

      end

      context 'content' do

        context 'properties' do

          it 'extracts the key from the left of the delimiter' do
            ini = subject.parse('key=value')
            ini[:key].should_not be_nil
          end

          it 'ignores whitespace before the key' do
            ini = subject.parse('    key=value')
            ini[:key].should eq 'value'
          end

          it 'throws an exception on a blank key' do
            lambda {
              subject.parse('   =value')
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on whitespace within the key' do
            lambda {
              subject.parse('this is the key=value')
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on punctuation within the key' do
            lambda {
              subject.parse("the'key=value")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception for a duplicate key' do
            lambda {
              subject.parse("key=value1\nkey=value2")
            }.should raise_error(IniFormatError)
          end

          it 'ignores the case of the key' do
            ini = subject.parse('KEY=value')
            ini[:key].should eq 'value'
          end

          it 'allows an equal sign as the delimiter' do
            ini = subject.parse('key=value')
            ini[:key].should eq 'value'
          end

          it 'allows a colon as the delimiter' do
            ini = subject.parse('key:value')
            ini[:key].should eq 'value'
          end

          it 'allows spaces before the delimiter' do
            ini = subject.parse('key  =value')
            ini[:key].should eq 'value'
          end

          it 'allows spaces after the delimiter' do
            ini = subject.parse('key:   value')
            ini[:key].should eq 'value'
          end

          it 'ignores single quotes around the value' do
            ini = subject.parse("key='value'")
            ini[:key].should eq 'value'
          end

          it 'ignores double quotes around the value' do
            ini = subject.parse('key="value"')
            ini[:key].should eq 'value'
          end

          it 'allows a blank value' do
            ini = subject.parse('key=')
            ini[:key].should be_empty
          end

          it 'allows spaces within the value' do
            ini = subject.parse('key=this is the value')
            ini[:key].should eq 'this is the value'
          end

          it 'allows punctuation within the value' do
            value = "+refs/heads/*:refs/remotes/origin/*"
            ini = subject.parse("fetch = #{value}")
            ini[:fetch].should eq value

            value = "url = git@github.com:jdantonio/ini_file.git"
            ini = subject.parse("url = #{value}")
            ini[:url].should eq value
          end

          it 'collapses concurrent space characters within the value' do
            ini = subject.parse("key=this   is\tthe    value")
            ini[:key].should eq 'this is the value'
          end

          it 'does not collapse concurrent space within quoted values' do
            ini = subject.parse("key='this   is\tthe    value'")
            ini[:key].should eq "this   is\tthe    value"
          end

          it 'preserves the case of the value' do
            ini = subject.parse('key=This is the VALUE')
            ini[:key].should eq 'This is the VALUE'
          end

          it 'allows line continuation when a line ends with a backslash' do
            pending
            ini = subject.parse("key=this\\\nvalue")
            ini[:key].should eq 'this value'
          end

        end

        context 'escape sequences' do

          it "converts \\\\ into \\" do
            ini = subject.parse("key=this\\\\value")
            ini[:key].should eq "this\\value"
          end

          it "converts \\0 into a null character" do
            ini = subject.parse("key=this\\0value")
            ini[:key].should eq "this\0value"
          end

          it "converts \\a into a bell/alert" do
            ini = subject.parse("key=this\\avalue")
            ini[:key].should eq "this\avalue"
          end

          it "converts \\b into a bell/alert" do
            ini = subject.parse("key=this\\bvalue")
            ini[:key].should eq "this\bvalue"
          end

          it "converts \\t into a tab" do
            ini = subject.parse("key=this\\tvalue")
            ini[:key].should eq "this\tvalue"
          end

          it "converts \\r into carriage return" do
            ini = subject.parse("key=this\\rvalue")
            ini[:key].should eq "this\rvalue"
          end

          it "converts \\n into a newline" do
            ini = subject.parse("key=this\\nvalue")
            ini[:key].should eq "this\nvalue"
          end

          it "converts \\; into a semicolon" do
            ini = subject.parse("key=this\\;value")
            ini[:key].should eq "this;value"
          end

          it "converts \\# into a number sign" do
            ini = subject.parse("key=this\\#value")
            ini[:key].should eq "this#value"
          end

          it 'converts \\x???? into a hexidecimal character' do
            ini = subject.parse("key=this\\x1234value")
            ini[:key].should eq "this\u1234value"
          end

          it 'converts \\u???? into a hexidecimal character' do
            ini = subject.parse("key=this\\u1234value")
            ini[:key].should eq "this\u1234value"
          end

        end

        context 'comments' do

          it 'ignores lines beginning with a semicolon' do
            ini = subject.parse(';this is a comment')
            ini.should be_empty
          end

          it 'ignores lines beginning with a pound sign' do
            ini = subject.parse('#this is a comment')
            ini.should be_empty
          end

          it 'ignores inline comments beginning with a semicolon in unquoted values' do
            ini = subject.parse("key = value ; comment")
            ini[:key].should eq "value"
          end

          it 'ignores inline comments beginning with a pound sign in unquoted values' do
            ini = subject.parse("key = value # comment")
            ini[:key].should eq "value"
          end

          it 'allows inline comments beginning with a semicolon in quoted values' do
            ini = subject.parse("key = \"value ; comment\"")
            ini[:key].should eq "value ; comment"
          end

          it 'allows inline comments beginning with a pound sign in quoted values' do
            ini = subject.parse('key = "value # comment"')
            ini[:key].should eq 'value # comment'
          end

          it 'allows equal signs within comments' do
            ini = subject.parse('  ;editor = mate -w')
            ini.should be_empty
          end

          it 'allows colons within comments' do
            ini = subject.parse('  #editor = mate -w')
            ini.should be_empty
          end

          it 'ignores spaces before the comment indicator' do
            ini = subject.parse('     # this is a comment')
            ini.should be_empty
          end

          it 'ignores blank lines' do
            ini = subject.parse("key1=value1\n   \n\t\n  \t key2=value2\n#comment")
            ini[:key1].should eq 'value1'
            ini[:key2].should eq 'value2'
          end

          it 'ignores empty lines' do
            ini = subject.parse("key1=value1\n\n\n\nkey2=value2")
            ini[:key1].should eq 'value1'
            ini[:key2].should eq 'value2'
          end

        end

        context 'sections' do

          it 'assigns properties before any section headers to the global section' do
            ini = subject.parse("key1=value1\n[section]\nkey2=value2")
            ini[:key1].should eq 'value1'
          end

          it 'assigns properties after a section header to that section' do
            ini = subject.parse("[section]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'allows whitespace before the opening bracket' do
            ini = subject.parse("    [section]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'ignores whitespace between the opening bracket and the section name' do
            ini = subject.parse("[    section]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'ignores whitespace between the closing bracket and the section name' do
            ini = subject.parse("[section    ]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'allows whitespace after the closing bracket' do
            ini = subject.parse("[section]    \nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'allows section names to be enclosed in double quotes' do
            ini = subject.parse("[ \"section\" ]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'allows section names to be enclosed in single quotes' do
            ini = subject.parse("[ 'section' ]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'throws an exception on punctuation within the section name' do
            lambda {
              subject.parse("[the'section]\nkey=value")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception when a section name is the same as a property key' do
            lambda {
              subject.parse("foo=value1\n[foo]\nkey2=value2")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on duplicate keys within a section' do
            lambda {
              subject.parse("[section]\nfoo=value1\n[section]\nfoo=value2")
            }.should raise_error(IniFormatError)
          end

          it 'ignores the case of the section name' do
            ini = subject.parse("[SeCtIoN]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a dot' do
            ini = subject.parse("[section.subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a backslash' do
            ini = subject.parse("[section\\subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a forward slash' do
            ini = subject.parse("[section/subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a comma' do
            ini = subject.parse("[section,subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by whitespace' do
            ini = subject.parse("[section subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'allows whitespace before the section delimiter' do
            ini = subject.parse("[section    .subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'allows whitespace after the section delimiter' do
            ini = subject.parse("[section.\t     subsection]\nkey=value")
            ini[:key].should be_nil
            ini[:section][:subsection][:key].should eq 'value'
          end

          it 'does not collide names when a section has subsections' do
            ini = subject.parse("[section]\nkey1=value1\n[section.subsection]\nkey2=value2")
            ini[:section].should be_a Hash
            ini[:section][:key1].should eq 'value1'
            ini[:section].count.should eq 2
            ini[:section][:subsection].should be_a Hash
            ini[:section][:subsection][:key2].should eq 'value2'
            ini[:section][:subsection].count.should eq 1
          end

          it 'allows a section to have a subsection with the same name' do
            ini = subject.parse("[section]\nkey1=value1\n[section.section]\nkey2=value2")
            ini[:section].should be_a Hash
            ini[:section][:key1].should eq 'value1'
            ini[:section].count.should eq 2
            ini[:section][:section].should be_a Hash
            ini[:section][:section][:key2].should eq 'value2'
            ini[:section][:section].count.should eq 1
          end

          it 'throws an exception when a section name is blank' do
            lambda {
              subject.parse("[      ]")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception when a subsection name is blank' do
            lambda {
              subject.parse("[head..subsection]")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception when a section name mixes hierarchy delimiters' do
            lambda {
              subject.parse("[this.is\\the/section,header]")
            }.should raise_error(IniFormatError)
          end

        end

        context 'multiple lines' do

          it 'supports multiple property lines' do
            ini = subject.parse("key1=value1\nkey2=value2")
            ini[:key1].should eq 'value1'
            ini[:key2].should eq 'value2'
          end

          it 'supports multiple comment lines' do
            ini = subject.parse(";this is a comment\n#this is also a comment")
            ini.should be_empty
          end

          it 'supports multiple blank lines' do
            ini = subject.parse("key1=value1\n\n\n\n\n\nkey2=value2")
            ini[:key1].should eq 'value1'
            ini[:key2].should eq 'value2'
          end

        end

        context 'garbage' do

          it 'throws an exception when encountering garbage lines' do
            lambda {
              subject.parse('this line is garbage')
            }.should raise_error(IniFormatError)
          end

        end

        context 'property data types' do

          it 'converts non-quoted integer property values to integers' do
            ini = subject.parse("key1 = 123")
            ini[:key1].should be_a Numeric
            ini[:key1].should eq 123
          end

          it 'converts non-quoted numeric property values to numbers' do
            ini = subject.parse("key1 = 123.45")
            ini[:key1].should be_a Numeric
            ini[:key1].should be_within(0.1).of(123.45)
          end
        end

      end
    end
  end
end
