require 'hashmake'

module SPNet
class InPort
  
  include Hashmake::HashMakeable
    
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => "UNNAMED"),
    :matching_port_class => arg_spec(:reqd => true, :type => Class),
  }

  attr_reader :name, :link
  
  def initialize args
    @arg_specs = InPort::ARG_SPECS
    hash_make args
    
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
