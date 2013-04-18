module SPNet

# Represent a Block object using only serializeable objects.
#
# @author James Tunnell
class BlockState
  include Hashmake::HashMakeable

  # Define arg specs to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :class_sym => arg_spec(:reqd => true, :type => Symbol),
    :params => arg_spec_hash(:reqd => false, :type => Object),
  }
  
  attr_reader :class_sym, :params
  
  # A new instance of NetworkState. 
  # @param [Hash] args Hashed arguments for initialization. See Network::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args
    hash_make BlockState::ARG_SPECS, args
  end
  
  # Produce a Block object from the current BlockState object.
  def make_block args
    raise ArgumentError, "args does not have :sample_rate key" unless args.has_key?(:sample_rate)
    
    klass = find_class(@class_sym)
    block = klass.new :sample_rate => args[:sample_rate]
    block.restore_state self
    
    return block
  end
  
  private
  
  def find_class sym
    s = sym.to_s
    parts = s.split("::")
    
    cur_space = Kernel
    
    for i in (0...(parts.count-1))
      cur_space = cur_space.const_get(parts[i].to_sym)
    end
    
    return cur_space.const_get parts.last.to_sym
  end
end
end
