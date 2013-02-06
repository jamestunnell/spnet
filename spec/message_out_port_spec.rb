require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::MessageOutPort do
  before :each do
    @processor = lambda do |message|
      return message.value
    end
    @in_port = SPNet::MessageInPort.new :processor => @processor, :message_type => SPNet::Message::VALUE
    @out_port = SPNet::MessageOutPort.new :message_type => SPNet::Message::VALUE
  end

  describe '#add_link' do
    it 'should add the given input port to links' do
      @out_port.add_link @in_port
      @out_port.links.count.should be 1
      @out_port.links.first.should eq(@in_port)
    end

    it 'should also link the output port to the given input port' do
      @out_port.add_link @in_port
      @in_port.link.should eq(@out_port)
    end

    it 'should raise ArgumentError if the given input port is already linked' do
      @out_port.add_link @in_port
      lambda { @out_port.add_link(@in_port) }.should raise_error(ArgumentError)
    end
    
    it 'should raise ArgumentError if port is not input port' do
      @out_port2 = SPNet::MessageOutPort.new :message_type => SPNet::Message::VALUE
      lambda { @out_port.add_link(@out_port2) }.should raise_error(ArgumentError)
    end

    it 'should raise ArgumentError if message_type of input port does not match that of output port' do
      @in_port2 = SPNet::MessageInPort.new  :processor => @processor,:message_type => SPNet::Message::COMMAND
      lambda { @out_port.add_link(@in_port2) }.should raise_error(ArgumentError)
    end
  end

  describe '#remove_link' do
    it 'should remove the given input port (if it is already linked to the output port)' do
      @out_port.add_link @in_port
      @out_port.remove_link @in_port
      @out_port.links.should be_empty
    end
  end
  
  describe '#send_message' do
    it 'should pass the given message via recv_message to the processing callback' do
      @out_port.add_link @in_port
      rv = @out_port.send_message SPNet::SetValueMessage.new(5)
      rv.first.should eq(5)
    end
  end
end
