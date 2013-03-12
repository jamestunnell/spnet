require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class BlockStateTestBlock < Block
  attr_reader :value1, :value2
  
  def initialize args = {}
    @value1, @value2 = 0, 0
    @sample_rate = 1.0
    
    super(
      :arg_specs => {},
      :sample_rate_port => ParamInPort.new(:get_value_handler => ->(){ @sample_rate }, :set_value_handler => ->(a){ @sample_rate = a} ),
      :algorithm => ->(a){},
      :in_ports => {
        "value1" => ParamInPort.new(
          :get_value_handler => ->(){ @value1 },
          :set_value_handler => ->(a){ @value1 = a },
        ),
        "value2" => ParamInPort.new(
          :get_value_handler => ->(){ @value2 },
          :set_value_handler => ->(a){ @value2 = a },
        )
      }
    )
  end
end

describe SPNet::BlockState do
  describe '.new' do
    it 'should assign block class' do
      block_state = BlockState.new :class_sym => :BlockStateTestBlock, :hashed_args => {}
      block_state.class_sym.should eq(:BlockStateTestBlock)
    end
    
    it 'should assign port params' do
      params = {
        "value1" => 0.0,
        "value2" => 1.0,
      }
      block_state = BlockState.new :class_sym => :BlockStateTestBlock, :hashed_args => {}, :port_params => params
      block_state.port_params.should eq(params)
    end
  end
  
  describe '#make_block' do
    before :all do
      @params = {
        "value1" => 0.1,
        "value2" => 0.9,
      }
      @class_sym = :BlockStateTestBlock
      block_state = BlockState.new :class_sym => @class_sym, :hashed_args => {}, :port_params => @params
      @block = block_state.make_block
    end
    
    it 'should make a block of the given class type' do
      @block.class.to_s.to_sym.should eq(@class_sym)
    end

    it 'should make a block using given port params' do
      @block.value1.should eq(@params["value1"])
      @block.value2.should eq(@params["value2"])
    end
  end
end
