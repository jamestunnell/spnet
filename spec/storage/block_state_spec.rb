require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::BlockState do
  describe '.new' do
    it 'should assign block class' do
      block_state = BlockState.new :class_sym => :TestBlock
      block_state.class_sym.should eq(:TestBlock)
    end
    
    it 'should assign port params' do
      params = {
        "VALUE1" => 0.0,
        "VALUE2" => 1.0,
      }
      block_state = BlockState.new :class_sym => :TestBlock, :port_params => params
      block_state.port_params.should eq(params)
    end
  end
  
  describe '#make_block' do
    before :all do
      @params = {
        "VALUE1" => 0.1,
        "VALUE2" => 0.9,
      }
      @class_sym = :TestBlock
      block_state = BlockState.new :class_sym => @class_sym, :port_params => @params
      @block = block_state.make_block :sample_rate => 2
    end
    
    it 'should make a block of the given class type' do
      @block.class.to_s.to_sym.should eq(@class_sym)
    end

    it 'should make a block using given port params' do
      @block.value1.should eq(@params["VALUE1"])
      @block.value2.should eq(@params["VALUE2"])
    end
  end
end
