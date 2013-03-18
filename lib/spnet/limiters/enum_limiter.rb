module SPNet
# Keeps values to those found in the given Enumerable object.
#
# @author James Tunnell
class EnumLimiter < Limiter
  attr_reader :values
  
  def initialize values
    raise ArgumentError, "values is not an Enumerable" unless values.is_a?(Enumerable)
    @values = values
  end
  
  # Limit the given value to those given by @values. If the given value is not
  # found, return the current value.
  def limit_value value, current_value
    if @values.include? value
      return value
    else
      return current_value
    end
  end
end

end
