
module SPNet
class Block
  include Hashmake::HashMakeable
  
  attr_reader :name, :in_ports, :out_ports
  
  DO_NOTHING = ->(){}
  
  HASHED_ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => "UNNAMED"),
    :algorithm => arg_spec(:reqd => false, :type => Proc, :default => DO_NOTHING),
    :in_ports => arg_spec_array(:reqd => false, :type => InPort),
    :out_ports => arg_spec_array(:reqd => false, :type => OutPort),
  }
  
  def initialize args = {}
    @arg_specs = Block::HASHED_ARG_SPECS
    hash_make args
  end
  
  def find_ports name, ignore_case = true
    matches = (@in_ports + @out_ports).select do |port|
      if ignore_case
        port.name.casecmp(name) == 0
      else
        port.name == name
      end
    end
    return matches
  end
  
  def find_first_port name, ignore_case = true
    return find_ports(name, ignore_case).first
  end
  
  def step count
    @algorithm.call count
  end
end
end
