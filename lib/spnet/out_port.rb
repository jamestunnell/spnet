require 'set'
require 'hashmake'

module SPNet
class OutPort

  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => "UNNAMED"),
    :matching_port_class => arg_spec(:reqd => true, :type => Class),
  }

  attr_reader :name, :links

  def initialize hashed_args = {}
    @arg_specs = OutPort::ARG_SPECS
    hash_make hashed_args
    
    @links = Set.new
  end
  
  def add_link link
    raise ArgumentError, "link #{link} is not a #{@matching_port_class}" unless link.is_a?(@matching_port_class)
    raise ArgumentError, "link #{link} is already linked" if link.link
    @links.add link
    link.set_link self
  end
  
  def remove_link link
    raise ArgumentError, "@links does not include link #{link}" unless @links.include? link
    @links.delete link
    link.clear_link
  end
  
  def remove_bad_links
    find_bad_links_and :remove
  end
  
  def correct_bad_links
    find_bad_links_and :correct
  end
  
  private
  
  def find_bad_links_and action
    marked = []
    
    @links.each do |link|
      bad = (link.link == nil) or (link.link != self)
      if bad
        marked.push link
      end
    end
    
    marked.each do |link|
      if action == :remove
        @links.delete link
      elsif action == :correct
        link.set_link self
      end
    end
  end

end
end