
module SPNet
class Block
  include Hashmake::HashMakeable
  
  attr_reader :name, :in_ports, :out_ports
  
  DO_NOTHING = ->(){}
  
  HASHED_ARG_SPECS = {
    :algorithm => arg_spec(:reqd => false, :type => Proc, :default => DO_NOTHING),
    :in_ports => arg_spec_hash(:reqd => false, :type => InPort),
    :out_ports => arg_spec_hash(:reqd => false, :type => OutPort),
  }
  
  def initialize args = {}
    @arg_specs = Block::HASHED_ARG_SPECS
    hash_make args
  end
  
  def step count
    @algorithm.call count
  end
end
end
