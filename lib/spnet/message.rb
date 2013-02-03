require 'hashmake'

module SPNet
class Message
  
  include Hashmake::HashMakeable
  
  CONTROL = :messageTypeControl
  COMMAND = :messageTypeCommand
  
  TYPES = [ CONTROL, COMMAND ]
  
  HASHED_ARGS_SPECS = [
    Hashmake::HashedArg.new(:reqd => true, :key => :type, :type => Symbol, :validator => ->(a){ TYPES.include?(a) } ),
    Hashmake::HashedArg.new(:reqd => false, :key => :data, :type => Object, :default => nil),
  ]
  
  attr_accessor :data
  attr_reader :type
  
  def initialize hashed_args = {}
    hash_make Message::HASHED_ARGS_SPECS, hashed_args
  end
end
end
