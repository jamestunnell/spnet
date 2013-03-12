require 'spcore'

module SPNet

# Recieves signal input for processing in a Block object.
#
# @author James Tunnell
class SignalInPort < InPort

  include Hashmake::HashMakeable
  
  # The default Range value given to @limits.
  DEFAULT_LIMITS = (-Float::MAX..Float::MAX)

  # Define arg specs to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :limits => arg_spec(:reqd => false, :type => Range, :default => DEFAULT_LIMITS)
  }
  
  attr_reader :limits, :queue

  # A new instance of SignalInPort.
  # @param [Hash] hashed_args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details.
  def initialize hashed_args = {}
    hash_make SignalInPort::ARG_SPECS, hashed_args
    
    @queue = []
    @skip_limiting = (@limits == DEFAULT_LIMITS)
    @limiter = SPCore::Limiters.make_range_limiter @limits

    super(:matching_class => SignalOutPort)
  end

  # Add values to queue.
  def enqueue_values values
    unless @skip_limiting
      for i in 0...values.count
        values[i] = @limiter.call(values[i])
      end
    end
    
    @queue.concat values
  end
  
  # Remove values to queue.
  # @param [Fixnum] count Number of values to remove.
  def dequeue_values count = @queue.count
    raise ArgumentError, "count is greater than @queue.count" if count > @queue.count
    @queue.slice!(0...count)
  end
  
end
end
