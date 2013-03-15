module SPNet
# Does not limit values at all.
#
# @author James Tunnell
class NoLimiter < Limiter
  # Does not limit at all. Return the given value.
  def limit_value value, current_value = nil
    return value
  end
end
end
