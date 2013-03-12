module SPNet

# Provides a means to list and execute commands in a Block object.
#
# @author James Tunnell
class CommandInPort < InPort
  
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :command_map => arg_spec_hash(:reqd => true, :type => Proc),
  }

  # A new instance of CommandInPort.
  # @param [Hash] hashed_args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details.
  def initialize hashed_args
    hash_make CommandInPort::ARG_SPECS, hashed_args
    super(:matching_class => CommandOutPort)
  end
  
  # List the commands that are available.
  def list_commands
    @command_map.keys
  end
  
  # Execute a command with the given data (nil by default).
  def exec_command command, data
    raise "Command #{command} not found in command list" unless @command_map.has_key?(command)
    @command_map[command].call data
  end  
end
end
