require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class PassThroughBlock < Block
  def initialize
    in_port = SignalInPort.new
    out_port = SignalOutPort.new
    
    pass_through = lambda do
      out_port.send_values(in_port.dequeue_values)
    end
    
    super(
      :algorithm => pass_through,
      :in_ports => { "IN" => in_port },
      :out_ports => { "OUT" => out_port },
    )
  end
end

describe SPNet::Network do
  context '.new' do
    its(:name) { should be_empty }
    its(:blocks) { should be_empty }
    its(:links) { should be_empty }
    
    it 'should set links' do
      a = PassThroughBlock.new
      b = PassThroughBlock.new
      link = Link.new(:from => a.out_ports["OUT"], :to => b.in_ports["IN"])
      network = Network.new(
        :blocks => { "A" => a, "B" => b },
        :links => [ link ]
      )
      a.out_ports["OUT"].link.should eq(link)
      b.in_ports["IN"].link.should eq(link)
    end
  end
  
end
