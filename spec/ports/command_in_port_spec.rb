require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::CommandInPort do
  before :each do
    @commands = ["add", "sub", "mul", "div"]

    list_commands_handler = lambda { return @commands }

    exec_command_handler = lambda do |command, data|
      x = data[0]
      y = data[1]
      
      case command
      when "add"
        return x + y
      when "sub"
        return x - y
      when "mul"
        return x * y
      when "div"
        return x / y
      end
    end
    
    @port = SPNet::CommandInPort.new :list_commands_handler => list_commands_handler, :exec_command_handler => exec_command_handler
  end

  describe '#list_commands' do
    it 'should pass back the return value from the list_commands handler' do
      @port.list_commands.should eq(@commands)
    end
  end
  
  describe '#exec_command' do
    it 'should pass the command and data to the exec_command handler, and pass back the return value' do
      @port.exec_command("add", [1,2]).should eq(3)
      @port.exec_command("sub", [5,4]).should eq(1)
      @port.exec_command("mul", [3,2]).should eq(6)
      @port.exec_command("div", [9,3]).should eq(3)
    end
  end
end
