module SPNet

# Execute commands for a connected CommandInPort object.
#
# @author James Tunnell
class CommandOutPort < OutPort

  # A new instance of CommandOutPort.
  def initialize
    super(:matching_class => CommandInPort)
  end
  
  # If linked, return the result of calling the connected CommandInPort object's
  # list_commands method. Otherwise, return false.
  def list_commands
    unless @link.nil?
      return @link.to.list_commands
    end
    return false
  end

  # If linked, return the result of calling the connected CommandInPort object's
  # exec_command method. Otherwise, return false.
  def exec_command command, data = nil
    unless @link.nil?
      return @link.to.exec_command(command, data)
    end
    return false
  end

end
end