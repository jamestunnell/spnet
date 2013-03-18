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

# Produce a LowerLimiter object, based on a specification string.
# @param [String] string The specification string, which should be of the format
#                        "[a" or "(a", where a is a number. Square bracket
#                        indicates an inclusive limit, and parenthesis indicates
#                        exclusive.
def make_lower_limiter string
  string = string.gsub(/\s*/, '')
  
  if string[0] == '['
    inclusive = true
  elsif string[0] == '('
    inclusive = false
  else
    raise ArgumentError, "string does not have '[' or '(' at beginning"
  end
  
  string[0] = ''
  
  limit = Limit.new(string.to_f, inclusive)
  return LowerLimiter.new(limit)
end

end
