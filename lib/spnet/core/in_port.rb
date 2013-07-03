module SPNet

# A port that exposes some functionality in a block.
#
# @author James Tunnell
class InPort
  include Hashmake::HashMakeable

  # Define ArgSpec's to use in processing hashed arguments during #initialize.  
  ARG_SPECS = {
    :matching_class => arg_spec(:reqd => true, :type => Class),
  }

  attr_reader :link, :matching_class
  
  # A new instance of InPort.
  # @param [Hash] args Hashed arguments for initialization. See InPort::ARG_SPECS
  #                    for details.
  def initialize args
    hash_make args, InPort::ARG_SPECS
    @link = nil
  end

  # Set @link to the given Link object.
  def set_link link
    raise ArgumentError, "link 'to' port is not self" unless link.to == self
    @link = link
  end

  # Set @link to nil.
  def clear_link
    @link = nil
  end

  # Return true if @link is not nil.
  def linked?
    !link.nil?
  end
end

end
