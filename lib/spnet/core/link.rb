module SPNet

# Form a connection between an OutPort and an InPort.
#
# @author James Tunnell
class Link
  include Hashmake::HashMakeable
  
  # Define arg specs to use in processing hashed arguments during #initialize.
  ARG_SPECS = {
    :from => arg_spec(:reqd => true, :type => OutPort),
    :to => arg_spec(:reqd => true, :type => InPort)
  }
  
  attr_reader :to, :from
  
  # A new instance of Link. Link is not active by default (does not set
  # from.link and to.link to self).
  # @param [Hash] args Hashed arguments for initialization. See Link::ARG_SPECS
  #                    for details of which keys are required.
  def initialize args = {}
    hash_make Link::ARG_SPECS, args
    
    raise ArgumentError, "from port class #{@from.class} is not a #{@to.matching_class}" unless @from.is_a?(@to.matching_class)
    raise ArgumentError, "to port class #{@to.class} is not a #{@from.matching_class}" unless @to.is_a?(@from.matching_class)
  end
  
  # Make the link active by setting from.link and to.link to self.
  def activate
    @from.set_link self
    @to.set_link self
  end
  
  # Make the link inactive by setting from.link and to.link to nil.
  def deactivate
    @from.clear_link
    @to.clear_link
  end
  
  # Return true if the link is active (from.link and to.link are set to to self).
  def active?
    (@from.link == self) && (@to.link == self)
  end

  # Produce a LinkState object from the current Link object.
  def export_state blocks
    from, to = nil, nil
    
    blocks.each do |block_name, block|
      block.out_ports.each do |port_name, port|
        if port == @from
          from = PortLocater.new(:block_name => block_name, :port_name => port_name)
          break
        end
      end
      
      block.in_ports.each do |port_name, port|
        if port == @to
          to = PortLocater.new(:block_name => block_name, :port_name => port_name)
          break
        end
      end
    end
    
    raise "could not find from port" if from.nil?
    raise "could not find to port" if to.nil?
    return LinkState.new(:from => from, :to => to)
  end
end
end
