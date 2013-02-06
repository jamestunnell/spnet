require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::OutPort do
  before :each do
    @in_port = SPNet::InPort.new :matching_port_class => SPNet::OutPort
    @out_port = SPNet::OutPort.new :matching_port_class => SPNet::InPort
  end
  
  describe '.new' do
    it 'should have no links' do
      @out_port.links.should be_empty
    end    
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
      out_port2 = SPNet::OutPort.new :matching_port_class => SPNet::InPort
      lambda { @out_port.add_link(out_port2) }.should raise_error(ArgumentError)
    end
  end

  describe '#remove_link' do
    it 'should remove the given input port (if it is already linked to the output port)' do
      @out_port.add_link @in_port
      @out_port.remove_link @in_port
      @out_port.links.should be_empty
    end
  end

end
