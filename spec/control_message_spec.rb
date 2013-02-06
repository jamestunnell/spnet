require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::ControlMessage do
  describe '.new' do
    it 'should set type to Message::CONTROL' do
      message = SPNet::ControlMessage.new :subtype => SPNet::ControlMessage::GET_VALUE
      message.type.should eq(SPNet::Message::CONTROL)
    end
    
    it 'should ignore attempt to override type' do
      message = SPNet::ControlMessage.new :subtype => SPNet::ControlMessage::GET_VALUE, :type => :fakeType
      message.type.should eq(SPNet::Message::CONTROL)
    end
    
    it 'should allow data to be set' do
      message = SPNet::ControlMessage.new :subtype => SPNet::ControlMessage::GET_VALUE, :data => 17
      message.data.should eq(17)
    end
  end
  
  describe '.make_set_message' do
    it 'should set data' do
      message = SPNet::ControlMessage.make_set_message 18
      message.data.should eq(18)
    end
    
    it 'should set subtype to ControlMessage::SET' do
      message = SPNet::ControlMessage.make_set_message 18
      message.subtype.should eq(SPNet::ControlMessage::SET_VALUE)
    end
  end

  describe '.make_get_message' do
    it 'should set subtype to ControlMessage::GET' do
      message = SPNet::ControlMessage.make_get_message
      message.subtype.should eq(SPNet::ControlMessage::GET_VALUE)
    end
  end

end
