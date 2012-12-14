require 'spec_helper'

module IniFile

  describe Contents do

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

    context '#new' do

      it 'calls Parser.parse with the contents' do
        ini_contents = 'key=value'
        Parser.should_receive(:parse).with(ini_contents)
        Contents.new(ini_contents)
      end

    end

    context 'accessor methods' do

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

    context 'iterators' do

      context '#each' do
        pending
      end

      context '#each_section' do
        pending
      end

      context '#each for sections' do
        pending
      end

    end
  end
end
