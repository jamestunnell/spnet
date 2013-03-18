module SPNet
# Keeps values between the given Limit objects.
#
# @author James Tunnell
class RangeLimiter < Limiter
  attr_reader :lower_limiter, :upper_limiter
  
  def initialize lower_value, lower_inclusive, upper_value, upper_inclusive
    @lower_limiter = LowerLimiter.new(lower_value, lower_inclusive)
    @upper_limiter = UpperLimiter.new(upper_value, upper_inclusive)
  end

  # Limit the given value to be between lower and upper limits. Ignores the current_value parameter.  
  def limit_value value, current_value = nil
    new_value = @lower_limiter.limit_value value
    if(new_value == value)
      # value is OK so far. Make sure the right (upper) limit is OK too.
      new_value = @upper_limiter.limit_value value
    end
    return new_value
  end
end

end
