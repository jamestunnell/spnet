module SPNet
# Keeps values at or below the given Limit.
#
# @author James Tunnell
class UpperLimiter < Limiter
  attr_reader :value, :inclusive
  
  def initialize limit, inclusive
    @limit = limit
    @inclusive = inclusive
  end

  # Limit the given value to be at or below @limit. Ignores the current_value parameter.
  def apply_limit value, current_value = nil
    if inclusive
      if value <= @limit
        return value
      else
        return @limit
      end
    else
      if value < @limit
        return value
      else
        return @limit - Float::EPSILON
      end
    end
  end
end

end
