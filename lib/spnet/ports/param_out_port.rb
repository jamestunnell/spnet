module SPNet

# Output value to a connected ParamInPort object.
#
# @author James Tunnell
class ParamOutPort < OutPort

  # A new instance of ParamOutPort.
  def initialize
    super(:matching_class => ParamInPort)
  end
  
  # If linked, return the result of calling the connected ParamInPort object's
  # set_value method. Otherwise, return false.
  def set_value value
    if linked?
      return @link.to.set_value value
    end
    return false
  end

  # If linked, return the result of calling the connected ParamInPort object's
  # get_value method. Otherwise, return false.
  def get_value
    if linked?
      return @link.to.get_value
    end
    return false
  end

end
end