require 'hashmake'

module SPNet
class CommandMessage < Message
  
  include Hashmake::HashMakeable
  
  LIST = :commandMessageSubtypeListCommands
  EXEC = :commandMessageSubtypeExecCommand
  
  SUBTYPES = [
    LIST,
    EXEC
  ]

  HASHED_ARGS_SPECS = [
    Hashmake::ArgSpec.new(:reqd => true, :key => :subtype, :type => Symbol, :validator => ->(a){ SUBTYPES.include?(a) } )
  ]
  
  attr_reader :subtype

  def initialize hashed_args
    hash_make CommandMessage::HASHED_ARGS_SPECS, hashed_args
    super(:type => COMMAND)
  end

  def self.make_handler list_handler, exec_handler
    handler = lambda do |message|
      raise ArgumentError, "message is not a CommandMessage" unless message.is_a?(CommandMessage)
      
      if message.subtype == LIST
        raise ArgumentError, "message is not a ListCommandsMessage" unless message.is_a?(ListCommandsMessage)
        return list_handler.call message
      elsif message.subtype == EXEC
        raise ArgumentError, "message is not a ExecCommandMessage" unless message.is_a?(ExecCommandMessage)
        return exec_handler.call message
      else
        raise ArgumentError, "message subtype #{message.subtype} is not valid"
      end
      
    end
    return handler
  end
end

class ListCommandsMessage < CommandMessage
  def initialize
    super(:subtype => LIST)
  end
end

class ExecCommandMessage < CommandMessage
  attr_reader :command, :data
  def initialize command, data = nil
    @command = command
    @data = data
    super(:subtype => EXEC)
  end
end

end
