
module SPNet
class Block
  include Hashmake::HashMakeable
  
  attr_reader :sample_rate, :in_ports, :out_ports
  
  HASHED_ARG_SPECS = {
    :arg_specs => arg_spec_hash(:reqd => true, :type => Hashmake::ArgSpec),
    :sample_rate => arg_spec(:reqd => true, :type => Float, :validator => ->(a){a > 0.0}),
    :sample_rate_handler => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 1 }),
    :algorithm => arg_spec(:reqd => true, :type => Proc, :validator => ->(p){ p.arity == 1 }),
    :in_ports => arg_spec_hash(:reqd => false, :type => InPort),
    :out_ports => arg_spec_hash(:reqd => false, :type => OutPort),
  }
  
  def initialize args = {}
    hash_make Block::HASHED_ARG_SPECS, args
  end
  
  def sample_rate= sample_rate
    @sample_rate_handler.call(sample_rate)
    @sample_rate = sample_rate
  end
  
  def step count
    @algorithm.call count
  end
  
  def export_state
    args = {}
    @arg_specs.each do |key, arg_spec|
      args[key] = self.instance_variables[key]
    end
    
    port_settings = {}
    @in_ports.each do |name, port|
      if port.is_a?(ValueInPort)
        port_settings[name] = port.get_value
      end
    end
    
    BlockState.new(:class_sym => self.class.to_s.to_sym, :args => args, :port_settings => port_settings)
  end
end
end
