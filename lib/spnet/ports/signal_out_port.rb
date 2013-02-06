require 'set'

module SPNet
class SignalOutPort < OutPort

  def initialize hashed_args = {}
    hashed_args.merge!(:matching_port_class => SignalInPort)
    super(hashed_args)
  end
  
  def send_values values
    @links.each do |link|
      link.enqueue_values values
    end
  end

end
end
