module SPNet

# Base class for encapsulating processing functionality. Connects to
# other blocks via input and output ports.
#
# @author James Tunnell
class Block
  include Hashmake::HashMakeable
  
  attr_reader :arg_specs, :sample_rate_port, :in_ports, :out_ports
  
  # Define ArgSpec's to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :arg_specs => arg_spec_hash(:reqd => true, :type => Hashmake::ArgSpec),
    :sample_rate_port => arg_spec(:reqd => true, :type => ParamInPort),
    :algorithm => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 1 }),
    :in_ports => arg_spec_hash(:reqd => false, :type => InPort),
    :out_ports => arg_spec_hash(:reqd => false, :type => OutPort),
  }
  
  # A new instance of Block.
  # @param [Hash] args Hashed arguments for initialization. See Block::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args = {}
    hash_make Block::ARG_SPECS, args
    
    @arg_specs.each do |key, arg_spec|
      unless self.methods.include?(key) || self.instance_variables.include?(("@" + key.to_s).to_sym)
        raise ArgumentError, "self does not have method or instance variable #{key}"
      end
    end
  end
  
  # Get the sample rate using the sample rate port.
  def sample_rate
    @sample_rate_port.get_value
  end
  
  # Set the sample rate using the sample rate port.
  # @raise [ArgumentError] if sample rate is not > 0.0.
  def sample_rate= sample_rate
    raise ArgumentError, "sample_rate is not > 0.0" unless sample_rate > 0.0
    @sample_rate_port.set_value sample_rate
  end
  
  # Execute the block algorithm.
  # @param [Fixnum] count The number of steps to execute. Passed on to the algorithm Proc.
  def step count
    @algorithm.call count
  end
  
  # Produces a BlockState object based on this Block object.
  # @return [BlockState]
  def export_state
    args = {}
    @arg_specs.each do |key, arg_spec|
      if self.methods.include?(key)
        args[key] = self.send(key)
      else
        args[key] = self.instance_variable_get(("@" + key.to_s).to_sym)
      end
    end
    
    port_params = {}
    @in_ports.each do |name, port|
      if port.is_a?(ParamInPort)
        port_params[name] = port.get_value
      end
    end
    
    BlockState.new(:class_sym => self.class.to_s.to_sym, :hashed_args => args, :port_params => port_params)
  end
end
end
