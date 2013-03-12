module SPNet

# Locate a port based on the block and port name, rather than an object reference.
#
# @author James Tunnell
class PortLocater
  include Hashmake::HashMakeable
  
  # Define arg specs to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :block_name => arg_spec(:reqd => true, :type => String),
    :port_name => arg_spec(:reqd => true, :type => String),
  }
  
  attr_reader :block_name, :port_name
  
  def initialize args
    hash_make ARG_SPECS, args
  end
end
end
