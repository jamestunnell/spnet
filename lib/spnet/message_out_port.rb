require 'set'
require 'hashmake'

module SPNet
class MessageOutPort
  include Hashmake::HashMakeable
  
  ARG_SPECS = [
    Hashmake::ArgSpec.new(:reqd => false, :key => :name, :type => String, :default => "UNNAMED"),
    Hashmake::ArgSpec.new(:reqd => true, :key => :message_type, :type => Symbol, :validator => ->(a){ Message::TYPES.include?(a) })
  ]
  
  attr_reader :name, :links, :message_type
  
  def initialize hashed_args = {}
    hash_make MessageOutPort::ARG_SPECS, hashed_args
    @links = Set.new
  end
  
  def send_message message
    rvs = []
    @links.each do |link|
      rvs.push link.recv_message message
    end
    return rvs
  end
  
  def add_link link
    raise ArgumentError, "link #{link} is not a MessageInPort" unless link.is_a?(MessageInPort)
    raise ArgumentError, "link #{link} is already linked to a MessageInPort" if link.link
    raise ArgumentError, "link.message_type #{link.message_type} does not match @message_type #{@message_type}" if link.message_type != @message_type
    @links.add link
    link.set_link self
  end
  
  def remove_link link
    raise ArgumentError, "link #{link} is not a MessageInPort" unless link.is_a?(MessageInPort)
    raise ArgumentError, "@links does not include link #{link}" unless @links.include? link
    @links.delete link
    link.clear_link
  end
  
  def remove_bad_links
    marked_for_removal = []
    
    @links.each do |link|
      bad = (link.link == nil) or (link.link != self)
      if bad
        marked_for_removal.push link
      end
    end
    
    marked_for_removal.each do |link|
      @links.delete link
    end
  end
end
end
