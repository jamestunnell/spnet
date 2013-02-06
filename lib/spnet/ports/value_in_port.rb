require 'hashmake'

module SPNet
class ValueInPort < InPort
  
  include Hashmake::HashMakeable

  ARG_SPECS = [
    Hashmake::ArgSpec.new(:key => :get_value_handler, :reqd => true, :type => Proc),
    Hashmake::ArgSpec.new(:key => :set_value_handler, :reqd => true, :type => Proc)
  ]

  def initialize hashed_args = {}
    hash_make(ValueInPort::ARG_SPECS, hashed_args)
    hashed_args.merge!(:matching_port_class => ValueOutPort)
    super(hashed_args)
  end
  
  def set_value value
    @set_value_handler.call value
  end
  
  def get_value
    @get_value_handler.call
  end
end
end
