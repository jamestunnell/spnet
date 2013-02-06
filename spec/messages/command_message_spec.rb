require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::CommandMessage do
  describe '.new' do
    it 'should set type to Message::COMMAND' do
      message = SPNet::CommandMessage.new :subtype => SPNet::CommandMessage::LIST
      message.type.should eq(SPNet::Message::COMMAND)
    end
    
    it 'should ignore attempt to override type' do
      message = SPNet::CommandMessage.new :subtype => SPNet::CommandMessage::LIST, :type => :fakeType
      message.type.should eq(SPNet::Message::COMMAND)
    end
  end
end
