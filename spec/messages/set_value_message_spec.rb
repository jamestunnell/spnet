require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::SetValueMessage do
  describe '.new' do
    it 'should set subtype to ValueMessage::SET' do
      message = SPNet::SetValueMessage.new 18
      message.subtype.should eq(SPNet::ValueMessage::SET)
    end

    it 'should set value' do
      message = SPNet::SetValueMessage.new 18
      message.value.should eq(18)
    end
  end

end
