require 'set'

module SPNet
class ValueOutPort < OutPort

  def initialize hashed_args = {}
    hashed_args.merge!(:matching_port_class => ValueInPort)
    super(hashed_args)
  end
  
  def set_value value
    rvs = []
    @links.each do |link|
      rvs.push link.set_value value
    end
    return rvs
  end

  def get_value
    rvs = []
    @links.each do |link|
      rvs.push link.get_value
    end
    return rvs
  end

end
end