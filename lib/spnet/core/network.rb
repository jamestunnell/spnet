module SPNet

# A signal processing network, formed by connecting Block objects with Link objects.
#
# @author James Tunnell
class Network
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Numeric, :validator => ->(a){a > 0.0}),
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :blocks => arg_spec_hash(:reqd => false, :type => Block),
    :links => arg_spec_array(:reqd => false, :type => Link),
  }
  
  attr_reader :sample_rate, :name, :blocks, :links
  
  # A new instance of Network. Changes all block sample rates (if necessary) to
  # match the given sample rate. Activates links.
  # @param [Hash] args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args = {}
    hash_make Network::ARG_SPECS, args
    
    # ensure that all sample rates match given rate
    @blocks.each do |block_name, block|
      if block.sample_rate != @sample_rate
        block.sample_rate = @sample_rate
      end
    end
    
    @links.each do |link|
      link.activate
    end
  end
  
  # Produce a NetworkState object from the current Network object.
  def export_state
    block_states = {}
    @blocks.each do |block_name, block|
      block_states[block_name] = block.export_state
    end
    
    link_states = []
    @links.each do |link|
      link_states.push link.export_state(@blocks)
    end
    
    return NetworkState.new(:name => @name, :block_states => block_states, :link_states => link_states)
  end
  
end
end