module SPNet
class Network
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => ""),
    :blocks => arg_spec_hash(:reqd => false, :type => Block),
    :links => arg_spec_array(:reqd => false, :type => Link),
    :activate_links => arg_spec(:reqd => false, :type => Object, :default => false)
  }
  
  attr_reader :name, :blocks, :links
  
  def initialize args = {}
    @arg_specs = Network::ARG_SPECS
    hash_make args
    
    if @activate_links
      @links.each do |link|
        link.activate
      end
    end
  end
  
end
end