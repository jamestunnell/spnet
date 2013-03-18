module SPNet
# Keeps values at or below the given Limit.
#
# @author James Tunnell
class UpperLimiter < Limiter
  attr_reader :limit
  
  def initialize value, inclusive
    @limit = Limit.new value, inclusive
  end

  # Limit the given value to be at or below @limit. Ignores the current_value parameter.
  def limit_value value, current_value = nil
    if @limit.inclusive?
      if value <= @limit.value
        return value
      else
        return @limit.value
      end
    else
      if value < @limit.value
        return value
      else
        return @limit.value - Float::EPSILON
      end
    end
  end
end

end
