module SPNet

# Output signal values to a connected SignalInPort object.
#
# @author James Tunnell
class SignalOutPort < OutPort

  # A new instance of SignalOutPort.
  def initialize
    super(:matching_class => SignalInPort)
  end
  
  # If linked, return the result of calling the connected SignalInPort object's
  # enqueue_values method. Otherwise, return false.
  def send_values values
    if linked?
      @link.to.enqueue_values values
    end
    return false
  end

end
end
