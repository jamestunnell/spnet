require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ListCommandsMessage do
  describe '.new' do
    it 'should set subtype to CommandMessage::LIST' do
      message = SPNet::ListCommandsMessage.new
      message.subtype.should eq(SPNet::CommandMessage::LIST)
    end
  end
end
