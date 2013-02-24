module SPNet

class InPort
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :matching_class => arg_spec(:reqd => true, :type => Class),
  }

  attr_reader :name, :link, :matching_class
  
  def initialize args
    @arg_specs = InPort::ARG_SPECS
    hash_make args
    
    @link = nil
  end

  def set_link link
    raise ArgumentError, "link 'to' port is not self" unless link.to == self
    @link = link
  end

  def clear_link
    @link = nil
  end
  
  def linked?
    !link.nil?
  end
end

end
