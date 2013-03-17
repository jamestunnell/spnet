module SPNet
# Keeps values between the given Limit objects.
#
# @author James Tunnell
class RangeLimiter < Limiter
  attr_reader :lower_limiter, :upper_limiter
  
  def initialize left_limit, right_limit
    @lower_limiter = LowerLimiter.new(left_limit)
    @upper_limiter = UpperLimiter.new(right_limit)
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

# Produce a RangeLimiter object, based on a specification string.
# @param [String] string The specification string, which should be of the format
#                        "[a,b]" or "(a,b]" or "[a,b)" or "(a,b)". Square bracket
#                        indicates an inclusive limit, and parenthesis indicates
#                        exclusive.
def make_range_limiter string
  string = string.gsub(/\s*/, '')
  
  if string[0] == '['
    lower_is_inclusive = true
  elsif string[0] == '('
    lower_is_inclusive = false
  else
    raise ArgumentError, "string does not have '[' or '(' at beginning"
  end

  if string[-1] == ']'
    upper_is_inclusive = true
  elsif string[-1] == ')'
    upper_is_inclusive = false
  else
    raise ArgumentError, "string does not have ']' or ')' at end"
  end
  
  string = string.gsub(/[\[\]\(\)]/,'')
  
  # make sure there is a separating comma
  scan_result = string.scan(/\,/)
  raise ArgumentError, "string has no comma" if scan_result.count == 0
  raise ArgumentError, "string has multiple commas" if scan_result.count > 1
  
  comma_idx = string.index(',')
  first = string[0...comma_idx]
  second = string[comma_idx+1...string.size]
  
  lower = Limit.new(first.to_f, lower_is_inclusive)
  upper = Limit.new(second.to_f, upper_is_inclusive)
  return RangeLimiter.new(lower, upper)
end

end
