require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SPNet::Block do
  context '.new' do
    context 'no I/O ports given' do
      before :all do
        @block = SPNet::Block.new
      end
      
      it 'should have no input ports' do
        @block.in_ports.should be_empty
      end

      it 'should have no output ports' do
        @block.out_ports.should be_empty
      end
    end
    
    context '1 in and 1 out port given' do
      before :all do
        @block = SPNet::Block.new(
          :in_ports => [SPNet::SignalInPort.new(:name => "IN")],
          :out_ports => [SPNet::SignalOutPort.new(:name => "OUT")],
        )
      end
      
      it 'should have 1 input port' do
        @block.in_ports.count.should be 1
        @block.in_ports.first.name.should eq("IN")
      end

      it 'should have 1 output port' do
        @block.out_ports.count.should be 1
        @block.out_ports.first.name.should eq("OUT")
      end      
    end
  end
end
