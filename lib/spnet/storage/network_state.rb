module SPNet
class NetworkState
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :sample_rate => arg_spec(:reqd => true, :type => Float, :validator => ->(a){a > 0.0}),
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :block_states => arg_spec_hash(:reqd => false, :type => BlockState),
    :link_states => arg_spec_array(:reqd => false, :type => LinkState),
  }
  
  attr_reader :sample_rate, :name, :block_models, :link_models
  
  def initialize args = {}
    hash_make NetworkState::ARG_SPECS, args
  end
  
  def make_network
    #raise ArgumentError, "args does not have :sample_rate key" unless args.has_key?(:sample_rate)
    #sample_rate = args[:sample_rate]
    
    blocks = {}
    @block_states.each do |block_name, block_state|
      blocks[block_name] = block_state.make_block
    end
    
    links = []
    @link_states.each do |link_state|
      links.push link_state.make_link blocks
    end
    
    Network.new :name => @name, :blocks => blocks, :links => links, :sample_rate => @sample_rate
  end
end
end
