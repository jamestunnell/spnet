module SPNet

# Defines a limit, where a value should not be above (for upper limit) or below
# (for lower limit). If inclusive is set to true, the limit indicates that values
# at the limit are OK.
#
# @author James Tunnell
class Limit
  attr_reader :value, :inclusive
  
  def inclusive?
    return @inclusive
  end
  
  def initialize value, inclusive
    @value = value
    @inclusive = inclusive
  end
end

# Base class for limiting values. Does nothing on it's own.
#
# @author James Tunnell
class Limiter
  def apply_limit value, current_value
    raise NotImplementedError
  end
end

end
