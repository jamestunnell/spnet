module SPNet
class Network
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Float, :validator => ->(a){a > 0.0}),
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :blocks => arg_spec_hash(:reqd => false, :type => Block),
    :links => arg_spec_array(:reqd => false, :type => Link),
  }
  
  attr_reader :sample_rate, :name, :blocks, :links
  
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
  
  def export_state
    block_states = {}
    @blocks.each do |block_name, block|
      block_states[block_name] = block.export_state
    end
    
    link_states = []
    @links.each do |link|
      link_states.push link.export_state(@blocks)
    end
    
    return NetworkState.new(
      :sample_rate => @sample_rate, :name => @name,
      :block_states => block_states, :link_states => link_states
    )
  end
  
end
end