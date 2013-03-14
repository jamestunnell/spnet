require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Network do
  context '.new' do
    before :all do
      @sample_rate =  1.0
    end
    
    context 'no name, blocks, or links given' do
      before :all do
        @network = Network.new :sample_rate => @sample_rate
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
      a = TestBlock.new(:sample_rate => @sample_rate)
      b = TestBlock.new(:sample_rate => @sample_rate)
      link = Link.new(:from => a.out_ports["OUT"], :to => b.in_ports["IN"])
      network = Network.new(
        :sample_rate => @sample_rate,
        :blocks => { "A" => a, "B" => b },
        :links => [ link ],
      )
      link.active?.should be_true
    end
  end
  
end
