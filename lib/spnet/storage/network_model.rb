module SPNet
class NetworkModel
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :block_models => arg_spec_hash(:reqd => false, :type => BlockModel),
    :link_models => arg_spec_array(:reqd => false, :type => LinkModel)
  }
  
  attr_reader :name, :block_models, :link_models
  
  def initialize args = {}
    @arg_specs = ARG_SPECS
    hash_make args
  end
  
  def make_network args
    raise ArgumentError, "args does not have :sample_rate key" unless args.has_key?(:sample_rate)
    sample_rate = args[:sample_rate]
    activate_links = args[:activate_links]
    
    blocks = {}
    @block_models.each do |block_name, block_model|
      blocks[block_name] = block_model.make_block sample_rate
    end
    
    links = []
    @link_models.each do |link_model|
      links.push link_model.make_link blocks
    end
    
    Network.new :name => @name, :blocks => blocks, :links => links, :activate_links => activate_links
  end
end
end
