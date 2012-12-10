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

          it 'throws an exception on whitespace within the key' do
            lambda {
              Contents.new('this is the key=value')
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on punctuation within the key' do
            lambda {
              Contents.new("the'key=value")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception for a duplicate key' do
            lambda {
              Contents.new("key=value1\nkey=value2")
            }.should raise_error(IniFormatError)
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
            subject = Contents.new("key='value'")
            subject[:key].should eq 'value'
          end

          it 'ignores double quotes around the value' do
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
            subject = Contents.new("key1=value1\n   \n\t\n  \t key2=value2\n#comment")
            subject[:key1].should eq 'value1'
            subject[:key2].should eq 'value2'
          end

          it 'ignores empty lines' do
            subject = Contents.new("key1=value1\n\n\n\nkey2=value2")
            subject[:key1].should eq 'value1'
            subject[:key2].should eq 'value2'
          end

        end

        context 'sections' do

          it 'assigns properties before any section headers to the global section' do
            subject = Contents.new("key1=value1\n[header]\nkey2=value2")
            subject[:key1].should eq 'value1'
          end

          #it 'requires section headers to be enclosed in square brackets' do
          #pending
          #end

          it 'assigns properties after a section header to that section' do
            subject = Contents.new("[header]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'allows whitespace before the opening bracket' do
            subject = Contents.new("    [header]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'ignores whitespace between the opening bracket and the header name' do
            subject = Contents.new("[    header]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'ignores whitespace between the closing bracket and the header name' do
            subject = Contents.new("[header    ]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'allows whitespace after the closing bracket' do
            subject = Contents.new("[header]    \nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'throws an exception on whitespace within the section name' do
            lambda {
              Contents.new("[the\theader]\nkey=value")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on punctuation within the section name' do
            lambda {
              Contents.new("[the'header]\nkey=value")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception when a section name is the same as a property key' do
            lambda {
              Contents.new("foo=value1\n[foo]\nkey2=value2")
            }.should raise_error(IniFormatError)
          end

          it 'throws an exception on duplicate keys within a section' do
            lambda {
              Contents.new("[header]\nfoo=value1\n[header]\nfoo=value2")
            }.should raise_error(IniFormatError)
          end

          it 'ignores the case of the section name' do
            subject = Contents.new("[HeAdeR]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a dot' do
            subject = Contents.new("[header.subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a backslash' do
            subject = Contents.new("[header\\subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a forward slash' do
            subject = Contents.new("[header/subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'creates a hierarchy when a section name is delimited by a comma' do
            subject = Contents.new("[header,subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'allows whitespace before the section delimiter' do
            subject = Contents.new("[header    .subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'allows whitespace after the section delimiter' do
            subject = Contents.new("[header.\t     subhead]\nkey=value")
            subject[:key].should be_nil
            subject[:header][:subhead][:key].should eq 'value'
          end

          it 'does not collide names when a section has subsections' do
            subject = Contents.new("[header]\nkey1=value1\n[header.subhead]\nkey2=value2")
            subject[:header].should be_a Hash
            subject[:header][:key1].should eq 'value1'
            subject[:header].count.should eq 2
            subject[:header][:subhead].should be_a Hash
            subject[:header][:subhead][:key2].should eq 'value2'
            subject[:header][:subhead].count.should eq 1
          end

          it 'allows a section to have a subsection with the same name' do
            subject = Contents.new("[header]\nkey1=value1\n[header.header]\nkey2=value2")
            subject[:header].should be_a Hash
            subject[:header][:key1].should eq 'value1'
            subject[:header].count.should eq 2
            subject[:header][:header].should be_a Hash
            subject[:header][:header][:key2].should eq 'value2'
            subject[:header][:header].count.should eq 1
          end

          it 'throws an exception when a section name mixes hierarchy delimiters' do
            pending
          end

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
            subject = Contents.new("key1=value1\n\n\n\n\n\nkey2=value2")
            subject[:key1].should eq 'value1'
            subject[:key2].should eq 'value2'
          end

        end

      end

    end

    context 'accessor methods' do

      let(:contents) do
        <<-DATA
          ; this line is a comment
          KEY1 = value1
          key2 = "The second value"

          [section_1]
          key3: value3

          [section_1.sub]
          key4 = "This is the fourth key"
        DATA
      end

      #let(:result) do
        #{
          #key1: 'value1',
          #key2: 'The second value',
          #section_1: {
            #key3: 'value3',
            #sub: {
              #key4: 'This is the fourth key'
            #}
          #}
        #}.freeze
      #end

      context 'attribute reader' do

        subject { Contents.new(contents) }

        it 'throws an ArgumentError if parameters are passed' do
          lambda { subject.key1(nil) }.should raise_error(ArgumentError)
        end

        it 'throws an ArgumentError if a block is provided' do
          lambda { subject.key1{|x| nil} }.should raise_error(ArgumentError)
        end

        it 'converts global property keys to attributes at the root' do
          subject.key1.should_not be_nil
        end

        it 'converts global property values to string values at the root' do
          subject.key1.should eq 'value1'
        end

        it 'ignores case of property keys' do
          subject.KEY1.should eq 'value1'
        end

        it 'converts section names to attributes at the root' do
          subject.section_1.should_not be_nil
        end

        it 'converts sections to nested attributes under the root' do
          subject.section_1[:key3].should eq 'value3'
        end

        it 'converts section property keys to attributes under the section' do
          subject.section_1.key3.should eq 'value3'
        end

        it 'converts section property values to string values under the section' do
          section = subject.section_1
          value = subject.section_1.key3
          subject.section_1.key3.should eq 'value3'
        end

        it 'converts section hierarchies to nested section hierarchies' do
          subject.section_1.sub.should_not be_nil
        end

        it 'ignores case of section names' do
          subject.SECTION_1[:key3].should eq 'value3'
        end

        it 'ignores case of section hierarchies' do
          subject.section_1.SUB.should_not be_nil
        end

        it 'ignores case of property names in section hierarchies' do
          subject.section_1.sub.KEY4.should eq 'This is the fourth key'
        end

        it 'throws NoMethodError when accessing a non-existing property' do
          lambda { subject.bogus }.should raise_error(NoMethodError)
        end

        it 'throws NoMethodError when accessing a non-existing section' do
          lambda { subject.bogus[:key1] }.should raise_error(NoMethodError)
        end

        it 'throws NoMethodError when accessing a non-existing subsection' do
          lambda { subject.section_1.bogus }.should raise_error(NoMethodError)
        end

        it 'throws NoMethodError when accessing a non-existing subsection property' do
          lambda { subject.section_1.sub.bogus }.should raise_error(NoMethodError)
        end

      end

      context '#[]' do

        subject { Contents.new(contents) }

        it 'converts global property keys to symbols at the root' do
          subject[:key1].should_not be_nil
          subject[:key2].should_not be_nil
        end

        it 'converts global property values to string values at the root' do
          subject[:key1].should eq 'value1'
          subject[:key2].should eq 'The second value'
        end

        it 'converts section names to symbols at the root' do
          subject[:section_1].should_not be_nil
        end

        it 'converts sections to hash values at the root' do
          subject[:section_1].should be_a Hash
        end

        it 'converts section property keys to symbols in the section hash' do
          subject[:section_1][:key3].should_not be_nil
        end

        it 'converts section property values to string values in the section hash' do
          subject[:section_1][:key3].should eq 'value3'
        end

        it 'converts section hierarchies to hash hierarchies' do
          subject[:section_1][:sub].should be_a Hash
        end

      end

      context '#to_hash' do

        subject { Contents.new(contents).to_hash }

        it 'converts global property keys to symbols at the root' do
          subject[:key1].should_not be_nil
          subject[:key2].should_not be_nil
        end

        it 'converts global property values to string values at the root' do
          subject[:key1].should eq 'value1'
          subject[:key2].should eq 'The second value'
        end

        it 'converts section names to symbols at the root' do
          subject[:section_1].should_not be_nil
        end

        it 'converts sections to hash values at the root' do
          subject[:section_1].should be_a Hash
        end

        it 'converts section property keys to symbols in the section hash' do
          subject[:section_1][:key3].should_not be_nil
        end

        it 'converts section property values to string values in the section hash' do
          subject[:section_1][:key3].should eq 'value3'
        end

        it 'converts section hierarchies to hash hierarchies' do
          subject[:section_1][:sub].should be_a Hash
        end

      end
    end
  end
end
