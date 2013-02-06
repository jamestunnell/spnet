require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ValueMessage do
  describe '.new' do
    it 'should set type to Message::VALUE' do
      message = SPNet::ValueMessage.new :subtype => SPNet::ValueMessage::GET
      message.type.should eq(SPNet::Message::VALUE)
    end
    
    it 'should ignore attempt to override type' do
      message = SPNet::ValueMessage.new :subtype => SPNet::ValueMessage::GET, :type => :fakeType
      message.type.should eq(SPNet::Message::VALUE)
    end
  end
end
