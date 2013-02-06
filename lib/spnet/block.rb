
module SPNet
class Block
  include Hashmake::HashMakeable
  
  attr_reader :name, :in_ports, :out_ports
  
  DO_NOTHING = ->(){}
  
  HASHED_ARG_SPECS = [
    Hashmake::ArgSpec.new(:reqd => false, :key => :name, :type => String, :default => "UNNAMED"),
    Hashmake::ArgSpec.new(:reqd => false, :key => :algorithm, :type => Proc, :default => DO_NOTHING),
    Hashmake::ArgSpec.new(:reqd => false, :key => :in_ports, :type => InPort, :container => Hashmake::ArgSpec::CONTAINER_ARRAY, :default => ->(){ Array.new } ),
    Hashmake::ArgSpec.new(:reqd => false, :key => :out_ports, :type => OutPort, :container => Hashmake::ArgSpec::CONTAINER_ARRAY, :default => ->(){ Array.new }),
  ]
  
  def initialize args = {}
    hash_make Block::HASHED_ARG_SPECS, args
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
