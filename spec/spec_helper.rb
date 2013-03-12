require 'rspec'
require 'spnet'

include SPNet

class TestBlock < Block
  include Hashmake::HashMakeable
  
  NAME_DEFAULT = ""
  VALUE_DEFAULT = 4
  
  ARG_SPECS = {
    :name => arg_spec(:reqd => false, :type => String, :default => NAME_DEFAULT),
    :value => arg_spec(:reqd => false, :type => Numeric, :default => VALUE_DEFAULT),
    :sample_rate => arg_spec(:reqd => false, :type => Fixnum, :default => 1)
  }
  
  attr_reader :value, :name
  
  def initialize args = {}
    hash_make TestBlock::ARG_SPECS, args
    
    @command_history = []
    
    sample_rate_port = ParamInPort.new(
      :get_value_handler => ->(){@sample_rate},
      :set_value_handler => ->(a){@sample_rate = a}
    )

    input = SignalInPort.new
    output = SignalOutPort.new

    value = ParamInPort.new(
      :get_value_handler => ->(){ @value },
      :set_value_handler => ->(a){ @value = a},
    )
    
    command = CommandInPort.new(
      :command_map => {
        "SIT" => ->(a){ @command_history.push("SIT") },
        "STAY" => ->(a){ @command_history.push("STAY") }
      }
    )

    pass_through = lambda do |count|
      output.send_values input.dequeue_values(count)
    end
    
    super(
      :arg_specs => TestBlock::ARG_SPECS,
      :sample_rate_port => sample_rate_port,
      :algorithm => pass_through,
      :in_ports => { "IN" => input, "VALUE" => value, "COMMAND" => command },
      :out_ports => { "OUT" => output }
    )
  end
end
