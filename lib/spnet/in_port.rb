require 'hashmake'

module SPNet
class InPort
  
  include Hashmake::HashMakeable
    
  ARG_SPECS = [
    Hashmake::ArgSpec.new(:reqd => false, :key => :name, :type => String, :default => "UNNAMED"),
    Hashmake::ArgSpec.new(:reqd => true, :key => :matching_port_class, :type => Class),
  ]

  attr_reader :name, :link
  
  def initialize args
    hash_make InPort::ARG_SPECS, args
    @link = nil
  end
  
  def clear_link
    @link = nil
  end
  
  def set_link link
    raise ArgumentError, "link #{link} is not a #{@matching_port_class}" unless link.is_a?(@matching_port_class)
    @link = link
  end
end
end
