require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Link do
  it 'should contain the :to and :from given' do
    out_port = SignalOutPort.new
    in_port = SignalInPort.new
    link = Link.new(:from => out_port,:to => in_port)
    
    link.to.should eq(in_port)
    link.from.should eq(out_port)
  end
  
  it 'should raise ArgumentError if to port does not match from port' do
    out_port = ValueOutPort.new
    in_port = SignalInPort.new
    lambda { Link.new(:from => out_port, :in => in_port) }.should raise_error(ArgumentError)
  end
end
