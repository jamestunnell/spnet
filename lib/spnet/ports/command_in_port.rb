require 'hashmake'

module SPNet
class CommandInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = [
    Hashmake::ArgSpec.new(:key => :command_map, :reqd => true, :type => Proc, :container => Hashmake::ArgSpec::CONTAINER_HASH),
  ]

  def initialize hashed_args
    hash_make(CommandInPort::ARG_SPECS, hashed_args)
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
