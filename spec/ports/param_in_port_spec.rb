require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ParamInPort do
  before :each do
    @value = 0
    
    set_value_handler = lambda do |value|
      return @value = value
    end
    
    get_value_handler = lambda do
      return @value
    end
    
    @port = SPNet::ParamInPort.new :get_value_handler => get_value_handler, :set_value_handler => set_value_handler
  end

  describe '#set_value' do
    it 'should pass the given value through the set_value handler' do
      rv = @port.set_value 5
      @value.should eq(5)
    end
  end
  
  describe '#get_value' do
    it 'should return the value from the get_value handler' do
      @value = 7
      @port.get_value.should eq(7)
    end
  end
end
