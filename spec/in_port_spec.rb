require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::InPort do
  describe '.new' do
    it 'should not have any links' do
      port = SPNet::InPort.new :matching_port_class => SPNet::OutPort
      port.link.should be_nil
    end
  end

  describe '#set_link' do
    it 'should set link to given OutPort' do
      in_port = SPNet::InPort.new :matching_port_class => SPNet::OutPort
      out_port = SPNet::OutPort.new :matching_port_class => SPNet::InPort
      in_port.set_link out_port
      in_port.link.should eq(out_port)
    end
  end
  
  describe '#clear_link' do
    it 'should set link to given OutPort' do
      in_port = SPNet::InPort.new :matching_port_class => SPNet::OutPort
      out_port = SPNet::OutPort.new :matching_port_class => SPNet::InPort
      in_port.set_link out_port
      in_port.clear_link
      in_port.link.should be_nil
    end
  end
end
