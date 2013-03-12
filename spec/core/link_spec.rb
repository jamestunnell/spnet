require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Link do
  context '.new' do
    it 'should contain the :to and :from given' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      
      link.to.should eq(in_port)
      link.from.should eq(out_port)
    end
    
    it 'should raise ArgumentError if to port does not match from port' do
      out_port = ParamOutPort.new
      in_port = SignalInPort.new
      lambda { Link.new(:from => out_port, :in => in_port) }.should raise_error(ArgumentError)
    end
    
    it 'should not set to and from link to eachother' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.to.link.should be_nil
      link.from.link.should be_nil
    end
  end

  context '#activate' do
    it 'should set.link to and from.link to self' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.activate
      link.to.link.should eq(link)
      link.from.link.should eq(link)
    end
  end

  context '#activate' do
    it 'should set.link to and from.link to nil' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.activate
      link.deactivate
      link.to.link.should eq(nil)
      link.from.link.should eq(nil)
    end
  end

  context '#active?' do
    it 'should return true if activate has been called and deactivate has never been called' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.activate
      link.active?.should be_true
    end

    it 'should return false if activate has never been called' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.active?.should be_false
    end

    it 'should return false if activate been called but deactivate was called later' do
      out_port = SignalOutPort.new
      in_port = SignalInPort.new
      link = Link.new(:from => out_port,:to => in_port)
      link.activate
      link.deactivate
      link.active?.should be_false
    end
  end
  
  context '#export_state' do
    before :all do
      blocks = {
        "A" => TestBlock.new,
        "B" => TestBlock.new,
      }
      link = Link.new(:from => blocks["A"].out_ports["OUT"], :to => blocks["B"].in_ports["IN"])
      link.activate
      @state = link.export_state blocks
    end
    
    it 'should make a LinkState object' do
      @state.should be_a(LinkState)
    end
      
    it 'should be from "A.OUT"' do
      @state.from.block_name.should eq("A")
      @state.from.port_name.should eq("OUT")      
    end
    
    it 'should be to "B.IN"' do
      @state.to.block_name.should eq("B")
      @state.to.port_name.should eq("IN")
    end
  end
end
