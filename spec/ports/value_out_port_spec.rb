require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ValueOutPort do
  before :each do
    @value = 0
    
    set_value_handler = lambda do |value|
      return @value = value
    end
    
    get_value_handler = lambda do
      return @value
    end
    
    @out_port = SPNet::ValueOutPort.new
    @in_port = SPNet::ValueInPort.new :get_value_handler => get_value_handler, :set_value_handler => set_value_handler
  end

  describe '#add_link' do
    it 'should raise ArgumentError if port is not ValueInPort' do
      @in_port2 = SPNet::SignalInPort.new
      lambda { @out_port.add_link(@in_port2) }.should raise_error(ArgumentError)
    end
  end

  describe '#set_value' do
    it 'should pass the given value through ValueInPort#set_value' do
      @out_port.add_link @in_port
      rv = @out_port.set_value 5
      @value.should eq(5)
    end
  end
  
  describe '#get_value' do
    it "should return the value from each linked port's ValueInPort#get_value" do
      @value = 7
      @out_port.add_link @in_port
      @out_port.get_value.first.should eq(7)
    end
  end
end
