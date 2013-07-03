module SPNet

# A port that is used to exercise some functionality exposed by an InPort.
#
# @author James Tunnell
class OutPort
  include Hashmake::HashMakeable
  
  # Define ArgSpec's to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :matching_class => arg_spec(:reqd => true, :type => Class),
  }

  attr_reader :name, :link, :matching_class

  # A new instance of OutPort.
  # @param [Hash] args Hashed arguments for initialization. See OutPort::ARG_SPECS
  #                    for details.  
  def initialize args
    hash_make args, OutPort::ARG_SPECS
    @link = nil
  end

  # Set @link to the given Link object.
  def set_link link
    raise ArgumentError, "link 'from' port is not self" unless link.from == self
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