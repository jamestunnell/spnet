module SPNet
class BlockModel
  include Hashmake::HashMakeable
  
  ARG_SPECS = {
    :block_class => arg_spec(:reqd => true, :type => Class),
    :port_settings => arg_spec_hash(:reqd => false, :type => Object)
  }
  
  attr_reader :block_class, :port_settings
  
  def initialize args
    @arg_specs = ARG_SPECS
    hash_make args
  end
  
  def make_block sample_rate
    block = @block_class.new :sample_rate => sample_rate
    
    @port_settings.each do |port_name,start_value|
      if block.in_ports.has_key?(port_name)
        port = block.in_ports[port_name]
        
        if port.is_a?(ValueInPort)
          port.set_value start_value
        elsif port.is_a?(CommandInPort)
          if start_value.is_a?(Array)
            command = start_value[0]
            data = start_value[1]
          else
            command = start_value
            data = nil
          end
          
          raise "Command #{command} not found in port command list" unless port.list_commands.include? command
          port.exec_command command, data
        else
        end
      end
    end
    
    return block
  end
end
end
