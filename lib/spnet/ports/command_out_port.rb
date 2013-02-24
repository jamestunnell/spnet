module SPNet
class CommandOutPort < OutPort

  def initialize
    super(:matching_class => CommandInPort)
  end
  
  def list_commands
    unless @link.nil?
      return @link.to.list_commands
    end
    return false
  end

  def exec_command command, data = nil
    unless @link.nil?
      return @link.to.exec_command(command, data)
    end
    return false
  end

end
end