require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::InPort do
  describe '.new' do
    it 'link should be nil' do
      port = InPort.new :matching_class => OutPort
      port.link.should be_nil
    end
  end

  describe '#set_link' do
    it 'should set link to given link' do
      in_port = InPort.new(:matching_class => OutPort)
      out_port = OutPort.new(:matching_class => InPort)
      link = Link.new :from => out_port, :to => in_port
      in_port.set_link link
      in_port.link.should eq(link)
    end
  end
  
  describe '#clear_link' do
    it 'should set link to nil' do
      in_port = InPort.new(:matching_class => OutPort)
      out_port = OutPort.new(:matching_class => InPort)
      link = Link.new :from => out_port, :to => in_port
      in_port.set_link link
      in_port.link.should eq(link)
      in_port.clear_link
      in_port.link.should be_nil
    end
  end
end
