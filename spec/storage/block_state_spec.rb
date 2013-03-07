require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class BlockStateTestBlock < Block
  attr_reader :value1, :value2
  
  def initialize args = {}
    @value1, @value2 = 0, 0
    
    super(
      :arg_specs => {},
      :sample_rate => 1.0,
      :sample_rate_handler => ->(a){},
      :algorithm => ->(a){},
      :in_ports => {
        "value1" => ValueInPort.new(
          :get_value_handler => ->(){ @value1 },
          :set_value_handler => ->(a){ @value1 = a },
        ),
        "value2" => ValueInPort.new(
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
    
    it 'should assign port settings' do
      settings = {
        "value1" => 0.0,
        "value2" => 1.0,
      }
      block_state = BlockState.new :class_sym => :BlockStateTestBlock, :hashed_args => {}, :port_settings => settings
      block_state.port_settings.should eq(settings)
    end
  end
  
  describe '#make_block' do
    before :all do
      @settings = {
        "value1" => 0.1,
        "value2" => 0.9,
      }
      @class_sym = :BlockStateTestBlock
      block_state = BlockState.new :class_sym => @class_sym, :hashed_args => {}, :port_settings => @settings
      @block = block_state.make_block
    end
    
    it 'should make a block of the given class type' do
      @block.class.to_s.to_sym.should eq(@class_sym)
    end

    it 'should make a block using given port settings' do
      @block.value1.should eq(@settings["value1"])
      @block.value2.should eq(@settings["value2"])
    end
  end
end
