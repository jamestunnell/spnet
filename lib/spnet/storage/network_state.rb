module SPNet

# Represents a Network object using only serializeable objects.
#
# @author James Tunnell
class NetworkState
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :block_states => arg_spec_hash(:reqd => false, :type => BlockState),
    :link_states => arg_spec_array(:reqd => false, :type => LinkState),
  }
  
  attr_reader :sample_rate, :block_models, :link_models
  
  # A new instance of NetworkState. 
  # @param [Hash] args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args = {}
    hash_make args, NetworkState::ARG_SPECS
  end
  
  # Produce a Network object from the current NetworkState object.
  # @param [Hash] args Hashed arguments. The only key required is :sample_rate.
  def make_network args
    raise ArgumentError, "args does not have :sample_rate key" unless args.has_key?(:sample_rate)
    sample_rate = args[:sample_rate]
    
    blocks = {}
    @block_states.each do |block_name, block_state|
      blocks[block_name] = block_state.make_block :sample_rate => sample_rate
    end
    
    links = []
    @link_states.each do |link_state|
      links.push link_state.make_link blocks
    end
    
    Network.new :blocks => blocks, :links => links, :sample_rate => sample_rate
  end
end
end
