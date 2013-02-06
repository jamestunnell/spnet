require 'hashmake'

module SPNet
class CommandInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = [
    Hashmake::ArgSpec.new(:key => :list_commands_handler, :reqd => true, :type => Proc),
    Hashmake::ArgSpec.new(:key => :exec_command_handler, :reqd => true, :type => Proc)
  ]

  def initialize hashed_args
    hash_make(CommandInPort::ARG_SPECS, hashed_args)
    hashed_args.merge!(:matching_port_class => CommandOutPort)
    super(hashed_args)
  end
  
  def list_commands
    @list_commands_handler.call
  end
  
  def exec_command command, data
    @exec_command_handler.call command, data
  end  
end
end
