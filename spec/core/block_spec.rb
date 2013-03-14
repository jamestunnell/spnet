require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Block do
  before :all do
    @sample_rate = 1.0
  end
  
  context '.new' do
    context 'no I/O ports given' do
      before :all do
        @block = SPNet::Block.new :sample_rate => @sample_rate, :algorithm => ->(a){}
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
          :sample_rate => @sample_rate, :algorithm => ->(a){},
          :in_ports => { "IN" => SPNet::SignalInPort.new }, :out_ports => { "OUT" => SPNet::SignalOutPort.new },
        )
      end
      
      it 'should have 1 input port' do
        @block.in_ports.count.should be 1
        @block.in_ports.has_key?("IN")
      end
  
      it 'should have 1 output port' do
        @block.out_ports.count.should be 1
        @block.out_ports.has_key?("OUT")
      end      
    end
  end

  context '#sample_rate' do
    it 'should return the given sample_rate' do
      block = TestBlock.new :sample_rate => @sample_rate
      block.sample_rate.should eq(@sample_rate)
    end
  end
    
  context '#step' do
    it 'should exercise the given algorithm, passing the count' do
      block = TestBlock.new :sample_rate => @sample_rate
      collector = SignalInPort.new
      link = Link.new(:from => block.out_ports["OUT"], :to => collector)
      link.activate
      block.in_ports["IN"].enqueue_values [1,3,5]
      block.step 1
      collector.dequeue_values(1).should eq([1])
      block.step 2
      collector.dequeue_values(2).should eq([3,5])
    end
  end
  
  context '#export_state' do
    before :all do
      block = TestBlock.new :sample_rate => @sample_rate
      block.in_ports["VALUE1"].set_value(4.4)
      block.in_ports["VALUE2"].set_value(5.5)
      @state = block.export_state
    end

    it 'should set class_sym to :Block' do
      @state.class_sym.should eq(:TestBlock)
    end

    it 'should set port_params according to ParamInPort settings' do
      @state.port_params.should eq("VALUE1" => 4.4, "VALUE2" => 5.5)
    end
  end
end
