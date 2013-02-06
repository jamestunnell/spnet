module SPNet
class CommandOutPort < OutPort

  def initialize hashed_args = {}
    hashed_args.merge!(:matching_port_class => CommandInPort)
    super(hashed_args)
  end
  
  def list_commands
    rvs = []
    @links.each do |link|
      rvs.push link.list_commands
    end
    return rvs
  end

  def exec_command command, data = nil
    rvs = []
    @links.each do |link|
      rvs.push link.exec_command(command, data)
    end
    return rvs
  end

end
end