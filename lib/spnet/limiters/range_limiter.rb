module SPNet
# Keeps values between the given Limit objects.
#
# @author James Tunnell
class RangeLimiter < Limiter
  attr_reader :lower, :upper
  
  def initialize lower_limit, lower_inclusive, upper_limit, upper_inclusive
    @lower = LowerLimiter.new(lower_limit, lower_inclusive)
    @upper = UpperLimiter.new(upper_limit, upper_inclusive)
  end

  # Limit the given value to be between lower and upper limits. Ignores the current_value parameter.  
  def apply_limit value, current_value = nil
    new_value = @lower.apply_limit value
    if(new_value == value)
      # value is OK so far. Make sure the right (upper) limit is OK too.
      new_value = @upper.apply_limit value
    end
    return new_value
  end
end

end
