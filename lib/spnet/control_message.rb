require 'hashmake'

module SPNet
class ControlMessage < Message

  include Hashmake::HashMakeable
  
  GET_VALUE = :controlMessageSubtypeGetValue
  SET_VALUE = :controlMessageSubtypeSetValue
  
  SUBTYPES = [
    GET_VALUE,
    SET_VALUE
  ]
  
  HASHED_ARGS_SPECS = [
    Hashmake::ArgSpec.new(:reqd => true, :key => :subtype, :type => Symbol, :validator => ->(a){ SUBTYPES.include?(a) } )
  ]
  
  attr_reader :subtype
  
  def initialize hashed_args
    hash_make ControlMessage::HASHED_ARGS_SPECS, hashed_args
    super_hashed_args = hashed_args.merge! :type => Message::CONTROL
    super(super_hashed_args)
  end
  
  def self.make_handler get_handler, set_handler
    handler = lambda do |message|
      raise ArgumentError, "message is not a ControlMessage" unless message.is_a?(ControlMessage)
      
      if message.subtype == GET_VALUE
        return get_handler.call message
      elsif message.subtype == SET_VALUE
        return set_handler.call message
      else
        raise ArgumentError, "message subtype #{message.subtype} is not valid"
      end
      
    end
    return handler
  end
  
  def self.make_set_message data
    ControlMessage.new :subtype => SET_VALUE, :data => data
  end

  def self.make_get_message
    ControlMessage.new :subtype => GET_VALUE
  end
end
end