require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class BlockModelTestBlock < Block
  attr_reader :value1, :value2
  
  def initialize args = {}
    @value1, @value2 = 0, 0
    
    super(
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

describe SPNet::BlockModel do
  describe '.new' do
    it 'should assign block class' do
      block_model = BlockModel.new :block_class => BlockModelTestBlock
      block_model.block_class.should eq(BlockModelTestBlock)
    end
    
    it 'should assign port settings' do
      settings = {
        "value1" => 0.0,
        "value2" => 1.0,
      }
      block_model = BlockModel.new :block_class => BlockModelTestBlock, :port_settings => settings
      block_model.port_settings.should eq(settings)
    end
  end
  
  describe '#make_block' do
    before :all do
      @settings = {
        "value1" => 0.1,
        "value2" => 0.9,
      }
      @block_class = BlockModelTestBlock
      block_model = BlockModel.new :block_class => @block_class, :port_settings => @settings
      @block = block_model.make_block 0.0
    end
    
    it 'should make a block of the given class type' do
      @block.class.should eq(@block_class)
    end

    it 'should make a block using given port settings' do
      @block.value1.should eq(@settings["value1"])
      @block.value2.should eq(@settings["value2"])
    end
  end
end
