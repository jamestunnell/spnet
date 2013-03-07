module SPNet
class ValueInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = {
    :get_value_handler => arg_spec(:reqd => true, :type => Proc),
    :set_value_handler => arg_spec(:reqd => true, :type => Proc)
  }

  def initialize hashed_args = {}
    hash_make ValueInPort::ARG_SPECS, hashed_args
    super(:matching_class => ValueOutPort)
  end
  
  def set_value value
    @set_value_handler.call value
  end
  
  def get_value
    @get_value_handler.call
  end
end
end
