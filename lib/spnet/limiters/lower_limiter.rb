module SPNet
# Keeps values at or above the given Limit.
#
# @author James Tunnell
class LowerLimiter < Limiter
  attr_reader :limit
  
  def initialize limit
    raise ArgumentError, "limit is not a Limit" unless limit.is_a?(Limit)
    @limit = limit
  end

  # Limit the given value to be at or above @limit. Ignores the current_value parameter.
  def limit_value value, current_value = nil
    if @limit.inclusive?
      if value >= @limit.value
        return value
      else
        return @limit.value
      end
    else
      if value > @limit.value
        return value
      else
        return @limit.value + Float::EPSILON
      end
    end
  end
end
end
