require 'hashmake'

module SPNet
class CommandInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = {
    :command_map => arg_spec_hash(:reqd => true, :type => Proc),
  }

  def initialize hashed_args
    @arg_specs = CommandInPort::ARG_SPECS
    hash_make hashed_args
    
    hashed_args.merge!(:matching_port_class => CommandOutPort)
    super(hashed_args)
  end
  
  def list_commands
    @command_map.keys
  end
  
  def exec_command command, data
    @command_map[command].call data
  end  
end
end
