require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ParamOutPort do
  before :each do
    @value = 0
    
    set_value_handler = lambda do |value|
      return @value = value
    end
    
    get_value_handler = lambda do
      return @value
    end
    
    @out_port = SPNet::ParamOutPort.new
    @in_port = SPNet::ParamInPort.new :get_value_handler => get_value_handler, :set_value_handler => set_value_handler
  end

  describe '#set_value' do
    it 'should pass the given value through ParamInPort#set_value' do
      @out_port.set_link Link.new(:to => @in_port, :from => @out_port)
      @out_port.set_value 5
      @value.should eq(5)
    end
  end
  
  describe '#get_value' do
    it "should return the value from each linked port's ParamInPort#get_value" do
      @value = 7
      @out_port.set_link Link.new(:to => @in_port, :from => @out_port)
      @out_port.get_value.should eq(7)
    end
  end
end
