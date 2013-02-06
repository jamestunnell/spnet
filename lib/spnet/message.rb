require 'hashmake'

module SPNet
class Message
  
  include Hashmake::HashMakeable
  
  VALUE = :messageTypeValue
  COMMAND = :messageTypeCommand
  
  TYPES = [ VALUE, COMMAND ]
  
  HASHED_ARGS_SPECS = [
    Hashmake::ArgSpec.new(:reqd => true, :key => :type, :type => Symbol, :validator => ->(a){ TYPES.include?(a) } ),
  ]
  
  attr_reader :type
  
  def initialize hashed_args = {}
    hash_make Message::HASHED_ARGS_SPECS, hashed_args
  end
end
end
