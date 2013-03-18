module SPNet

# Recieves signal input for processing in a Block object.
#
# @author James Tunnell
class SignalInPort < InPort

  include Hashmake::HashMakeable
  
  # Define arg specs to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :limiter => arg_spec(:reqd => false, :type => Limiter, :default => ->(){ NoLimiter.new }, :validator => ->(a){ !a.is_a?(EnumLimiter) }),
  }
  
  attr_reader :limiter, :queue

  # A new instance of SignalInPort.
  # @param [Hash] hashed_args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details.
  def initialize hashed_args = {}
    hash_make SignalInPort::ARG_SPECS, hashed_args
    
    @queue = []
    @skip_limiting = @limiter.is_a?(NoLimiter)

    super(:matching_class => SignalOutPort)
  end

  # Add values to queue.
  def enqueue_values values
    unless @skip_limiting
      for i in 0...values.count
        values[i] = @limiter.apply_limit values[i]
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
