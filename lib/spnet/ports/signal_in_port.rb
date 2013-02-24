require 'spcore'

module SPNet
class SignalInPort < InPort

  include Hashmake::HashMakeable
  
  DEFAULT_LIMITS = (-Float::MAX..Float::MAX)
  
  ARG_SPECS = {
    :limits => arg_spec(:reqd => false, :type => Range, :default => DEFAULT_LIMITS)
  }
  
  attr_reader :limits, :queue

  def initialize hashed_args = {}
    @arg_specs = SignalInPort::ARG_SPECS
    hash_make hashed_args
    
    @queue = []
    @skip_limiting = (@limits == DEFAULT_LIMITS)
    @limiter = SPCore::Limiters.make_range_limiter @limits

    super(:matching_class => SignalOutPort)
  end

  def enqueue_values values
    unless @skip_limiting
      for i in 0...values.count
        values[i] = @limiter.call(values[i])
      end
    end
    
    @queue.concat values
  end
  
  def dequeue_values count = @queue.count
    raise ArgumentError, "count is greater than @queue.count" if count > @queue.count
    @queue.slice!(0...count)
  end
  
end
end
