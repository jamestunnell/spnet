require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::ValueOutPort do
  before :each do
    @in_port = SPNet::CommandInPort.new(
      :command_map => {
        :add => lambda {|data| data[0] + data[1] },
        :sub => lambda {|data| data[0] - data[1] },
        :mul => lambda {|data| data[0] * data[1] },
        :div => lambda {|data| data[0] / data[1] },
      }
    )
    @out_port = SPNet::CommandOutPort.new
  end

  describe '#add_link' do
    it 'should raise ArgumentError if port is not ValueInPort' do
      @in_port2 = SPNet::SignalInPort.new
      lambda { @out_port.add_link(@in_port2) }.should raise_error(ArgumentError)
    end
  end

  describe '#list_commands' do
    it 'should pass back the return value from the list_commands handler' do
      @out_port.add_link @in_port
      @out_port.list_commands.should eq([[:add, :sub, :mul, :div]])
    end
  end
  
  describe '#exec_command' do
    it 'should pass the command and data to the exec_command handler, and pass back the return value' do
      @out_port.add_link @in_port
      @out_port.exec_command(:add, [1,2]).should eq([3])
      @out_port.exec_command(:sub, [5,4]).should eq([1])
      @out_port.exec_command(:mul, [3,2]).should eq([6])
      @out_port.exec_command(:div, [9,3]).should eq([3])
    end
  end

end
