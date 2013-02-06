require 'hashmake'
require 'spcore'

module SPNet
class SignalInPort < InPort

  include Hashmake::HashMakeable
  
  DEFAULT_LIMITS = (-Float::MAX..Float::MAX)
  
  ARG_SPECS = [
    Hashmake::ArgSpec.new(:reqd => false, :key => :limits, :type => Range, :default => DEFAULT_LIMITS)
  ]
  
  attr_reader :limits, :queue

  def initialize hashed_args = {}
    hash_make(SignalInPort::ARG_SPECS, hashed_args)
    @queue = []
    @skip_limiting = (@limits == DEFAULT_LIMITS)
    @limiter = SPCore::Limiters.make_range_limiter @limits

    hashed_args.merge!(:matching_port_class => SignalOutPort)
    super(hashed_args)
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
