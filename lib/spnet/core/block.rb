module SPNet

# Base class for encapsulating processing functionality. Connects to
# other blocks via input and output ports.
#
# @author James Tunnell
class Block
  include Hashmake::HashMakeable
  
  attr_reader :in_ports, :out_ports, :sample_rate
  
  # Define ArgSpec's to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){ a > 0 }),
    :algorithm => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 1 }),
    :in_ports => arg_spec_hash(:reqd => false, :type => InPort),
    :out_ports => arg_spec_hash(:reqd => false, :type => OutPort),
  }
  
  # A new instance of Block.
  # @param [Hash] args Hashed arguments for initialization. See Block::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args = {}
    hash_make args, Block::ARG_SPECS
    @initial_params = collect_params
  end
  
  # Execute the block algorithm.
  # @param [Fixnum] count The number of steps to execute. Passed on to the algorithm Proc.
  def step count
    @algorithm.call count
  end
  
  # Produces a BlockState object based on this Block object.
  # @return [BlockState]
  def save_state
    params = collect_params
    
    # discard the params that are the same as the initial port params
    params.keys.each do |key|
      if params[key] == @initial_params[key]
        params.delete key
      end
    end
    
    BlockState.new(:class_sym => self.class.to_s.to_sym, :params => params)
  end

  def restore_state state
    state.params.each do |port_name,value|
      if @in_ports.has_key?(port_name)
        @in_ports[port_name].set_value value
      end
    end
  end
  
  private
  
  def collect_params
    params = {}
    
    @in_ports.each do |name, port|
      if port.is_a?(ParamInPort)
        params[name] = port.get_value
      end
    end
    
    return params
  end
end
end
