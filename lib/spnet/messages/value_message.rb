require 'hashmake'

module SPNet
class ValueMessage < Message

  include Hashmake::HashMakeable
  
  GET = :valueMessageSubtypeGet
  SET = :valueMessageSubtypeSet
  
  SUBTYPES = [
    GET,
    SET
  ]
  
  HASHED_ARGS_SPECS = [
    Hashmake::ArgSpec.new(:reqd => true, :key => :subtype, :type => Symbol, :validator => ->(a){ SUBTYPES.include?(a) } )
  ]
  
  attr_reader :subtype
  
  def initialize hashed_args
    hash_make ValueMessage::HASHED_ARGS_SPECS, hashed_args
    super(:type => VALUE)
  end
  
  def self.make_handler get_handler, set_handler
    handler = lambda do |message|
      raise ArgumentError, "message is not a ValueMessage" unless message.is_a?(ValueMessage)
      
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
end

class GetValueMessage < ValueMessage
  def initialize
    super(:subtype => GET)
  end
end

class SetValueMessage < ValueMessage
  attr_reader :value
  def initialize value
    @value = value
    super(:subtype => SET)
  end
end
end