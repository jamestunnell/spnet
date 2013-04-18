module SPNet

# Output signal values to a connected SignalInPort object.
#
# @author James Tunnell
class SignalOutPort < OutPort

  attr_reader :queue

  # A new instance of SignalOutPort.
  def initialize
    @queue = []
    super(:matching_class => SignalInPort)
  end
  
  # Add values to queue or send them directly to linked port
  # (if autosend is true).
  # @param [Array] values The values to add.
  # @param [true/false] autosend If true, and this port is linked to another
  #                              port, skip this port's queue and enqueue values
  #                              directly on the linked port's queue.
  def enqueue_values values, autosend = true
    if autosend && linked?
      @link.to.enqueue_values values
    else
      @queue.concat values
    end
  end

  # Remove values to queue.
  # @param [Fixnum] count Number of values to remove.
  def dequeue_values count = @queue.count
    raise ArgumentError, "count is greater than @queue.count" if count > @queue.count
    @queue.slice!(0...count)
  end  
end
end
