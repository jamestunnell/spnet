module SPNet
# Keeps values at or below the given Limit.
#
# @author James Tunnell
class UpperLimiter < Limiter
  attr_reader :limit
  def initialize limit
    raise ArgumentError, "limit is not a Limit" unless limit.is_a?(Limit)
    @limit = limit
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

# Produce a UpperLimiter object, based on a specification string.
# @param [String] string The specification string, which should be of the format
#                        "a]" or "a)", where a is a number. Square bracket
#                        indicates an inclusive limit, and parenthesis indicates
#                        exclusive.
def make_upper_limiter string
  string = string.gsub(/\s*/, '')
  
  if string[-1] == ']'
    inclusive = true
  elsif string[-1] == ')'
    inclusive = false
  else
    raise ArgumentError, "string does not have ']' or ')' at end"
  end
  
  string[-1] = ''
  
  limit = Limit.new(string.to_f, inclusive)
  return UpperLimiter.new(limit)
end

end
