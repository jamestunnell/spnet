module SPNet
# This class is intended to be used in place of a Link, when a
# Network is being stored to a file.
class PortLocater
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :block_name => arg_spec(:reqd => true, :type => String),
    :port_name => arg_spec(:reqd => true, :type => String),
  }
  
  attr_reader :block_name, :port_name
  
  def initialize args
    @arg_specs = ARG_SPECS
    hash_make args
  end
end
end
