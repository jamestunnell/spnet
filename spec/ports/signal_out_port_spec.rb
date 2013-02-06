require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::SignalOutPort do
  before :each do
    @out_port = SPNet::SignalOutPort.new
    @in_port = SPNet::SignalInPort.new
  end
  
  describe '#add_link' do    
    it 'should raise ArgumentError if port is not input port' do
      out_port2 = SPNet::SignalOutPort.new
      lambda { @out_port.add_link(out_port2) }.should raise_error(ArgumentError)
    end
  end

  describe '#send_values' do
    context 'single linked input port' do
      it 'should enqueue the values on the linked input port' do
        @out_port.add_link @in_port
        
        @in_port.queue.should be_empty
        @out_port.send_values [1,2,3,4]
        @in_port.queue.should eq([1,2,3,4])      
      end
    end

    context 'several linked input ports' do
      it 'should enqueue the values on each linked input port' do
        in_port1 = SPNet::SignalInPort.new
        in_port2 = SPNet::SignalInPort.new(:name => 'def')
        in_port3 = SPNet::SignalInPort.new(:name => 'ghi')
        
        @out_port.add_link in_port1
        @out_port.add_link in_port2
        @out_port.add_link in_port3
        
        in_port1.queue.should be_empty
        in_port2.queue.should be_empty
        in_port3.queue.should be_empty
        
        @out_port.send_values [1,2,3,4]
        
        in_port1.queue.should eq([1,2,3,4])
        in_port2.queue.should eq([1,2,3,4])
        in_port3.queue.should eq([1,2,3,4])
      end
    end
  end

end
