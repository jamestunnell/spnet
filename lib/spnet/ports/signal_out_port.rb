require 'set'

module SPNet
class SignalOutPort < OutPort

  def initialize hashed_args = {}
    super(:matching_class => SignalInPort)
  end
  
  def send_values values
    unless @link.nil?
      @link.to.enqueue_values values
    end
    return false
  end

end
end
