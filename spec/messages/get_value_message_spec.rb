require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::GetValueMessage do
  describe '.new' do
    it 'should set subtype to ValueMessage::GET' do
      message = SPNet::GetValueMessage.new
      message.subtype.should eq(SPNet::ValueMessage::GET)
    end
  end
end
