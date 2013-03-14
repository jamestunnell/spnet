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
    hash_make Block::ARG_SPECS, args
  end
  
  # Execute the block algorithm.
  # @param [Fixnum] count The number of steps to execute. Passed on to the algorithm Proc.
  def step count
    @algorithm.call count
  end
  
  # Produces a BlockState object based on this Block object.
  # @return [BlockState]
  def export_state
    port_params = {}
    @in_ports.each do |name, port|
      if port.is_a?(ParamInPort)
        port_params[name] = port.get_value
      end
    end
    
    BlockState.new(:class_sym => self.class.to_s.to_sym, :port_params => port_params)
  end
end
end
