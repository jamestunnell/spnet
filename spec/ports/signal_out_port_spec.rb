require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::SignalOutPort do
  before :each do
    @out_port = SPNet::SignalOutPort.new
    @in_port = SPNet::SignalInPort.new
  end
  
  describe '#send_values' do
    it 'should enqueue the values on the linked input port' do
      @out_port.set_link Link.new(:to => @in_port, :from => @out_port)
      
      @in_port.queue.should be_empty
      @out_port.send_values [1,2,3,4]
      @in_port.queue.should eq([1,2,3,4])
    end
  end

end
