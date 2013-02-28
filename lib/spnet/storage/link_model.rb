module SPNet
class LinkModel
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :from => arg_spec(:reqd => true, :type => PortLocater),
    :to => arg_spec(:reqd => true, :type => PortLocater)
  }
  
  attr_reader :from, :to
  
  def initialize args
    @arg_specs = ARG_SPECS
    hash_make args
  end
  
  def make_link blocks
    raise "from block #{@from.block_name} not found" unless blocks.has_key?(@from.block_name)
    raise "to block #{@to.block_name} not found" unless blocks.has_key?(@to.block_name)
    
    from_block = blocks[@from.block_name]
    to_block = blocks[@to.block_name]
    
    raise "from port #{@from.port_name} not found" unless from_block.out_ports.has_key?(@from.port_name)
    raise "to port #{@to.port_name} not found" unless to_block.in_ports.has_key?(@to.port_name)
    
    from_port = from_block.out_ports[@from.port_name]
    to_port = to_block.in_ports[@to.port_name]
    
    return Link.new(:from => from_port, :to => to_port)
  end
end
end
