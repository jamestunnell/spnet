module SPNet

# Represent a Block object using only serializeable objects.
#
# @author James Tunnell
class BlockState
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :class_sym => arg_spec(:reqd => true, :type => Symbol),
    :hashed_args => arg_spec(:reqd => true, :type => Hash),
    :port_params => arg_spec_hash(:reqd => false, :type => Object)
  }
  
  attr_reader :class_sym, :hashed_args, :port_params
  
  # A new instance of NetworkState. 
  # @param [Hash] args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args
    hash_make BlockState::ARG_SPECS, args
  end
  
  # Produce a Block object from the current BlockState object.
  def make_block
    klass = Kernel.const_get(@class_sym)
    block = klass.new @hashed_args
    
    @port_params.each do |port_name,value|
      if block.in_ports.has_key?(port_name)
        port = block.in_ports[port_name]
        port.set_value value
      end
    end
    
    return block
  end
end
end
