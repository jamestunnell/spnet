require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::MessageInPort do
  describe '#recv_message' do
    before :all do
      processor = lambda do |message|
        return message.value
      end
      @port = SPNet::MessageInPort.new :processor => processor, :message_type => SPNet::Message::VALUE
    end
    
    it 'should pass the given message to the processing callback' do
      rv = @port.recv_message SPNet::SetValueMessage.new(5)
      rv.should eq(5)
    end
  end
end
