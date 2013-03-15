module SPNet
# Keeps values between the given Limit objects.
#
# @author James Tunnell
class RangeLimiter < Limiter
  def initialize left_limit, right_limit
    @left_limiter = LowerLimiter.new(left_limit)
    @right_limiter = UpperLimiter.new(right_limit)
  end

  # Limit the given value to be between lower and upper limits. Ignores the current_value parameter.  
  def limit_value value, current_value = nil
    new_value = @left_limiter.limit_value value
    if(new_value == value)
      # value is OK so far. Make sure the right (upper) limit is OK too.
      new_value = @right_limiter.limit_value value
    end
    return new_value
  end
end
end
