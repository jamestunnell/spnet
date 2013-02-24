module SPNet
class Network
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :blocks => arg_spec_hash(:reqd => false, :type => Block),
    :links => arg_spec_array(:reqd => false, :type => Link)
  }
  
  attr_reader :name, :blocks, :links
  
  def initialize args = {}
    @arg_specs = Network::ARG_SPECS
    hash_make args
    
    @links.each do |link|
      found_from = false
      found_to = false
      @blocks.each do |name,block|
        if block.in_ports.values.include?(link.to)
          link.to.set_link link
          found_to = true
        end
        
        if block.out_ports.values.include?(link.from)
          link.from.set_link link
          found_from = true
        end
      end
    end
  end
  
end
end