require 'spec_helper'

module IniFile

  describe Content do

    let(:contents) do
      <<-DATA
        ; this line is a comment
        KEY1 = value1
        key2 = "The second value"
        the-third-key = 3

        [section_1]
        key3: value3

        [section_1.sub_1]
        sub_1_key: 'This is the subsection key'

        [section_1/sub_1/sub_2]
        key: value

        [section_1 \ sub_1 \ sub_2 \ sub_3]
        key: value

        [section_1,sub_1,sub_2,sub_3,sub_4]
        key: value
      DATA
    end

    context '#new' do

      it 'calls Parser.parse with the contents' do
        ini_contents = 'key=value'
        Parser.should_receive(:parse).with(ini_contents)
        Content.parse(ini_contents)
      end

    end

    context 'accessor methods' do

      context 'attribute reader' do

        subject { Content.parse(contents) }

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

        it 'replaces dashes in the key name with underscores' do
          subject.the_third_key.should eq 3
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
          subject.section_1.sub_1.sub_2.sub_3.sub_4.should_not be_nil
        end

        it 'ignores case of section names' do
          subject.SECTION_1[:key3].should eq 'value3'
        end

        it 'ignores case of section hierarchies' do
          subject.section_1.SUB_1.should_not be_nil
        end

        it 'ignores case of property names in section hierarchies' do
          subject.section_1.sub_1.SUB_1_KEY.should eq 'This is the subsection key'
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

        subject { Content.parse(contents) }

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

        it 'converts sections to nodes' do
          subject[:section_1].should be_kind_of IniFile::Content
        end

        it 'converts section property keys to symbols in the section hash' do
          subject[:section_1][:key3].should_not be_nil
        end

        it 'converts section property values to string values in the section hash' do
          subject[:section_1][:key3].should eq 'value3'
        end

        it 'converts section hierarchies to node hierarchies' do
          subject[:section_1].should be_kind_of IniFile::Content
          subject[:section_1][:sub_1].should be_kind_of IniFile::Content
          subject[:section_1][:sub_1][:sub_2].should be_kind_of IniFile::Content
          subject[:section_1][:sub_1][:sub_2][:sub_3].should be_kind_of IniFile::Content
          subject[:section_1][:sub_1][:sub_2][:sub_3][:sub_4].should be_kind_of IniFile::Content
        end

      end

      context '#to_hash' do

        subject { Content.parse(contents).to_hash }

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
          subject[:section_1][:sub_1][:sub_2][:sub_3][:sub_4].should be_a Hash
        end

      end

    end

    context 'iterators' do

      let(:contents) do
        <<-DATA
          ; this line is a comment
          KEY1 = value1
          key2 = "The second value"

          [section_1]
          key1-1: value1
          key1-2: value2
          key1-3: value3
          key1-4: value4

          [section_2]
          key2-1: value1
          key2-2: value2
          key2-3: value3
          key2-4: value4

          [section_1.sub_1]
          key1-1-1: value1
          key1-1-2: value2
          key1-1-3: value3
          key1-1-4: value4

          [section_1.sub_2]
          key1-2-1: value1
          key1-2-2: value2
          key1-2-3: value3
          key1-2-4: value4
        DATA
      end

      let(:keys) { [ :key1, :key2 ] }
      let(:sections) { [ :section_1, :section_2 ] }
      let(:section_keys) { [ :key1_1, :key1_2, :key1_3, :key1_4 ] }
      let(:subsections) { [ :sub_1, :sub_2 ] }
      let(:subsection_keys) { [ :key2_1, :key2_2, :key2_3, :key2_4 ] }
      let(:subsection_1_keys) { [ :key1_1_1, :key1_1_2, :key1_1_3, :key1_1_4 ] }
      let(:subsection_2_keys) { [ :key1_2_1, :key1_2_2, :key1_2_3, :key1_2_4 ] }

      subject { Content.parse(contents) }

      context '#each' do

        it 'iterates over each key/value pair in the global section' do
          subject.each do |key, value|
            keys.should include key
          end
        end

        it 'returns the value associated with the current key' do
          subject.each do |key, value|
            subject[key].should eq value
          end
        end

        it 'does not iterate over sections at the root' do
          subject.each do |key, value|
            sections.should_not include key
          end
        end

      end

      context '#each_section' do

        it 'iterates over each section in the root' do
          subject.each_section do |section|
            sections.should include section.name
          end
        end

        it 'returns the node associated with the current section' do
          subject.each_section do |section|
            section.should be_kind_of IniFile::Content
          end
        end

        it 'does not iterate over properties at the root' do
          subject.each_section do |section|
            keys.should_not include section.name
          end
        end

      end

      context '#each for sections' do

        it 'iterates over each key/value pair in the given section' do
          subject.section_1.each do |key, value|
            section_keys.should include key
          end
        end

        it 'returns the value associated with the current key' do
          subject.section_1.each do |key, value|
            subject.section_1[key].should eq value
          end
        end

        it 'does not iterate over subsections of the given section' do
          subject[:section_1].each do |key, value|
            subsections.should_not include key
          end
        end

      end

      context '#each_section for sections' do

        it 'iterates over each section in the root' do
          subject.section_1.each_section do |section|
            subsections.should include section.name
          end
        end

        it 'returns the node associated with the current section' do
          subject.section_1.each_section do |section|
            section.should be_kind_of IniFile::Content
          end
        end

        it 'does not iterate over properties at the root' do
          subject.section_1.each_section do |section|
            subsection_keys.should_not include section.name
          end
        end

      end

    end
  end
end
