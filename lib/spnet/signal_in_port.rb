require 'hashmake'

module SPNet
class SignalInPort
  include Hashmake::HashMakeable
  
  DEFAULT_LIMITS = (-Float::MAX..Float::MAX)
  
  ARG_SPECS = [
    Hashmake::ArgSpec.new(:reqd => false, :key => :name, :type => String, :default => "UNNAMED"),
    Hashmake::ArgSpec.new(:reqd => false, :key => :limits, :type => Range, :default => DEFAULT_LIMITS)
  ]
  
  attr_reader :name, :limits, :link, :queue
  
  def make_range_limiter range
    return lambda do |input|
      if input < range.first
        return range.first
      elsif input > range.last
        return range.last
      else
        return input
      end
    end
  end
  
  def initialize args = {}
    hash_make SignalInPort::ARG_SPECS, args
    @queue = []
    @skip_limiting = (@limits == DEFAULT_LIMITS)
    @limiter = make_range_limiter @limits
    @link = nil
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
  
  def clear_link
    @link = nil
  end
  
  def set_link link
    raise ArgumentError, "link #{link} is not a SignalOutPort" unless link.is_a?(SignalOutPort)
    @link = link
  end
end
end
