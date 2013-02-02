require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNetwork::MessageInPort do
  describe '#recv_message' do
    before :all do
      processor = lambda do |message|
        return message
      end
      @port = SPNetwork::MessageInPort.new :processor => processor, :message_type => SPNetwork::Message::CONTROL
    end
    
    it 'should pass the given message to the processing callback' do
      rv = @port.recv_message SPNetwork::ControlMessage.make_set_message(5)
      rv.data.should eq(5)
    end
  end
end
