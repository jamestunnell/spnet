require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::CommandInPort do
  before :each do
    @port = SPNet::CommandInPort.new(
      :command_map => {
        :add => lambda {|data| data[0] + data[1] },
        :sub => lambda {|data| data[0] - data[1] },
        :mul => lambda {|data| data[0] * data[1] },
        :div => lambda {|data| data[0] / data[1] },
      }
    )
  end

  describe '#list_commands' do
    it 'should pass back the return value from the list_commands handler' do
      @port.list_commands.should eq([:add, :sub, :mul, :div])
    end
  end
  
  describe '#exec_command' do
    it 'should pass the command and data to the exec_command handler, and pass back the return value' do
      @port.exec_command(:add, [1,2]).should eq(3)
      @port.exec_command(:sub, [5,4]).should eq(1)
      @port.exec_command(:mul, [3,2]).should eq(6)
      @port.exec_command(:div, [9,3]).should eq(3)
    end
  end
end
