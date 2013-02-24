require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::OutPort do
  describe '.new' do
    it 'link should be nil' do
      port = OutPort.new :matching_class => InPort
      port.link.should be_nil
    end
  end

  describe '#set_link' do
    it 'should set link to given link' do
      in_port = InPort.new(:matching_class => OutPort)
      out_port = OutPort.new(:matching_class => InPort)
      link = Link.new :from => out_port, :to => in_port
      out_port.set_link link
      out_port.link.should eq(link)
    end
  end
  
  describe '#clear_link' do
    it 'should set link to nil' do
      in_port = InPort.new(:matching_class => OutPort)
      out_port = OutPort.new(:matching_class => InPort)
      link = Link.new :from => out_port, :to => in_port
      out_port.set_link link
      out_port.link.should eq(link)
      out_port.clear_link
      out_port.link.should be_nil
    end
  end
end
