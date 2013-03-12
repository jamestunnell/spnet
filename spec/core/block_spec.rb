require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::Block do
  before :all do
    @sample_rate = 1.0
    @sample_rate_port = ParamInPort.new(:get_value_handler => ->(){@sample_rate}, :set_value_handler => ->(a){@sample_rate = a})
  end
  
  context '.new' do
    context 'no I/O ports given' do
      before :all do
        @block = SPNet::Block.new :arg_specs => {}, :sample_rate_port => @sample_rate_port, :algorithm => ->(a){}
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
          :arg_specs => {}, :sample_rate_port => @sample_rate_port, :algorithm => ->(a){},
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
    it 'should use the sample_rate port to get the sample rate' do
      block = TestBlock.new :sample_rate => 2
      block.sample_rate.should eq(2)
    end
  end
  
  context '#sample_rate' do
    it 'should use the sample_rate port to set the sample rate' do
      block = TestBlock.new :sample_rate => 2
      block.sample_rate = 3
      block.sample_rate.should eq(3)
    end
  end
  
  context '#step' do
    it 'should exercise the given algorithm, passing the count' do
      block = TestBlock.new
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
    context 'no arg specs given' do
      before :all do
        @block = SPNet::Block.new(
          :arg_specs => {}, :sample_rate_port => @sample_rate_port, :algorithm => ->(a){},
          :in_ports => { "IN" => SPNet::SignalInPort.new }, :out_ports => { "OUT" => SPNet::SignalOutPort.new },
        )
        @block.export_state.hashed_args.should be_empty
      end
      
      it 'should produce empty args' do
        @block.export_state.hashed_args.should be_empty
      end
    end
    
    context 'arg specs given' do
      context 'no args given' do
        it 'should use defaults' do
          state = TestBlock.new.export_state
          state.hashed_args[:name].should eq(TestBlock::NAME_DEFAULT)
          state.hashed_args[:value].should eq(TestBlock::VALUE_DEFAULT)
        end
      end

      context 'args given' do
        it 'should use given values' do
          state = TestBlock.new(:name => "NOPE", :value => 25).export_state
          state.hashed_args[:name].should eq("NOPE")
          state.hashed_args[:value].should eq(25)          
        end
      end
    end
  end
end
