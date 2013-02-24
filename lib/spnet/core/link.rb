module SPNet
class Link
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :from => arg_spec(:reqd => true, :type => OutPort),
    :to => arg_spec(:reqd => true, :type => InPort)
  }
  
  attr_reader :to, :from
  
  def initialize args = {}
    @arg_specs = Link::ARG_SPECS
    hash_make args
    
    raise ArgumentError, "from port class #{@from.class} is not a #{@to.matching_class}" unless @from.is_a?(@to.matching_class)
    raise ArgumentError, "to port class #{@to.class} is not a #{@from.matching_class}" unless @to.is_a?(@from.matching_class)
  end
end
end
