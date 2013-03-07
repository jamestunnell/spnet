module SPNet
class CommandInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = {
    :command_map => arg_spec_hash(:reqd => true, :type => Proc),
  }

  def initialize hashed_args
    hash_make CommandInPort::ARG_SPECS, hashed_args
    super(:matching_class => CommandOutPort)
  end
  
  def list_commands
    @command_map.keys
  end
  
  def exec_command command, data
    raise "Command #{command} not found in command list" unless @command_map.has_key?(command)
    @command_map[command].call data
  end  
end
end
