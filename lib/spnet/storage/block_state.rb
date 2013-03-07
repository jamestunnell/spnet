module SPNet
class BlockState
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :class_sym => arg_spec(:reqd => true, :type => Symbol),
    :hashed_args => arg_spec(:reqd => true, :type => Hash),
    :port_settings => arg_spec_hash(:reqd => false, :type => Object)
  }
  
  attr_reader :class_sym, :args, :port_settings
  
  def initialize args
    hash_make BlockState::ARG_SPECS, args
  end
  
  def make_block
    klass = Kernel.const_get(@class_sym)
    block = klass.new @hashed_args
    
    @port_settings.each do |port_name,start_value|
      if block.in_ports.has_key?(port_name)
        port = block.in_ports[port_name]
        port.set_value start_value
      end
    end
    
    return block
  end
end
end
