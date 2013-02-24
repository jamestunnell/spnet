require 'set'

module SPNet
class ValueOutPort < OutPort

  def initialize
    super(:matching_class => ValueInPort)
  end
  
  def set_value value
    unless @link.nil?
      return @link.to.set_value value
    end
    return false
  end

  def get_value
    unless @link.nil?
      return @link.to.get_value
    end
    return false
  end

end
end