require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class PassThroughBlock < Block
  def initialize
    in_port = SignalInPort.new
    out_port = SignalOutPort.new
    
    pass_through = lambda do |count|
      out_port.send_values(in_port.dequeue_values count)
    end
    
    super(
      :arg_specs => {},
      :sample_rate => 1.0,
      :sample_rate_handler => ->(a){},
      :algorithm => pass_through,
      :in_ports => { "IN" => in_port },
      :out_ports => { "OUT" => out_port },
    )
  end
end

describe SPNet::Network do
  context '.new' do
    context 'no name, blocks, or links given' do
      before :all do
        @network = Network.new :sample_rate => 1.0
      end
      
      it 'should have empty name' do
        @network.name.should be_empty
      end
      
      it 'should have no blocks' do
        @network.blocks.should be_empty
      end
      
      it 'should have no links' do
        @network.links.should be_empty
      end
    end
    
    it 'should set links' do
      a = PassThroughBlock.new
      b = PassThroughBlock.new
      link = Link.new(:from => a.out_ports["OUT"], :to => b.in_ports["IN"])
      network = Network.new(
        :sample_rate => 1.0,
        :blocks => { "A" => a, "B" => b },
        :links => [ link ],
      )
      a.out_ports["OUT"].link.should eq(link)
      b.in_ports["IN"].link.should eq(link)
    end
  end
  
end
