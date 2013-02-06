require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::Message do
  describe '.new' do
    it 'should set type' do
      message = SPNet::Message.new :type => SPNet::Message::VALUE
      message.type.should eq(SPNet::Message::VALUE)
    end
  end
end
