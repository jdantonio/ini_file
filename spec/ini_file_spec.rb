require 'spec_helper'

# http://en.wikipedia.org/wiki/INI_file

describe IniFile do

  subject { IniFile }

  let(:filename) { 'test.ini' }

  context '.load' do

    it 'throws an exception if the file does not exist' do
      pending
      lambda { subject.load(filename) }.should raise_error
    end

    it 'throws an exception on inadequate file permissions'

    it 'passes the file contents to a new Contents object'

    it 'bubbles any exceptions thrown by the Contents constructor'

    it 'returns the new contents object'

  end

end
