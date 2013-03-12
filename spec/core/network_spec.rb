require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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
    
    it 'should activate links' do
      a = TestBlock.new
      b = TestBlock.new
      link = Link.new(:from => a.out_ports["OUT"], :to => b.in_ports["IN"])
      network = Network.new(
        :sample_rate => 1.0,
        :blocks => { "A" => a, "B" => b },
        :links => [ link ],
      )
      link.active?.should be_true
    end
  end
  
end
