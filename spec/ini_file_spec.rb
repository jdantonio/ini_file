require 'fileutils'
require 'spec_helper'

# http://en.wikipedia.org/wiki/INI_file

describe IniFile do

  subject { IniFile }

  let(:filename) { 'test.ini' }
  let(:contents) { '; this is a comment' }

  def write_ini_file(path = '.')
    File.open(File.join(path, filename), 'w') {|f| f.write(contents) }
  end

  context '#parse' do

    it 'returns a hash on success' do
      subject.parse(contents).should be_a Hash
    end

    it 'bubbles any exceptions thrown by the Parser' do
      lambda { subject.parse('garbage') }.should raise_error
    end

    it 'returns nil on error when safe is set to true' do
      subject.parse('garbage', true).should be_nil
    end

  end

  context '#load' do

    it 'throws an exception if the file does not exist' do
      lambda { subject.load(filename) }.should raise_error
    end

    it 'throws an exception on inadequate file permissions' do
      #pending 'FakeFS is not properly setting file permissions'
      #write_ini_file
      #FileUtils.chmod(0222, filename)
      File.stub(:open).and_raise(Errno::EACCES)
      lambda { subject.load(filename) }.should raise_error
    end

    it 'passes the file contents to the Parser' do
      write_ini_file
      IniFile::Parser.should_receive(:parse).with(contents)
      subject.load(filename)
    end

    it 'expands the full file path' do
      write_ini_file(ENV['HOME'])
      lambda { subject.load(File.join("~/#{filename}")) }.should_not raise_error
    end

    it 'bubbles any exceptions thrown by the Content parser' do
      File.open(filename, 'w') {|f| f.write(contents) }
      IniFile::Content.stub(:parse).with(any_args()).and_raise(StandardError.new('test exception'))
      lambda { subject.load(filename) }.should raise_error(StandardError)
    end

    it 'returns the new contents object' do
      File.open(filename, 'w') {|f| f.write(contents) }
      IniFile.load(filename).should be_instance_of IniFile::Content
    end

    it 'returns nil on error when safe is set to true' do
      subject.load('file that does not exist', true).should be_nil
    end

  end

end
