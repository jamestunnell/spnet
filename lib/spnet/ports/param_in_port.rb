module SPNet

# Provides a means to get/set a parameter value in a Block object.
#
# @author James Tunnell
class ParamInPort < InPort
  
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :limiter => arg_spec(:reqd => false, :type => Limiter, :default => ->(){ NoLimiter.new } ),
    :get_value_handler => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 0 }),
    :set_value_handler => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 1 })
  }

  attr_reader :limiter
  
  # A new instance of ParamInPort.
  # @param [Hash] hashed_args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details.
  def initialize hashed_args = {}
    hash_make hashed_args, ParamInPort::ARG_SPECS
    @skip_limiting = @limiter.is_a?(NoLimiter)
    
    super(:matching_class => ParamOutPort)
  end
  
  # Set the parameter to the given value.
  def set_value value
    unless @skip_limiting
      value = @limiter.apply_limit value, get_value
    end
    @set_value_handler.call value
  end
  
  # Get the parameter's current value.
  def get_value
    @get_value_handler.call
  end
end
end
