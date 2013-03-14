require 'rspec'
require 'spnet'

include SPNet

class TestBlock < Block
  attr_reader :value1, :value2
  
  def initialize args
    raise ArgumentError, "args does not have :sample_rate key" unless args.has_key?(:sample_rate)
    raise ArgumentError, "sample_rate is not > 0.0" unless args[:sample_rate] > 0.0
    
    @sample_rate = args[:sample_rate]
    @value1 = 1
    @value2 = 2
    @command_history = []
    
    sample_rate_port = ParamInPort.new(
      :get_value_handler => ->(){@sample_rate},
      :set_value_handler => ->(a){@sample_rate = a}
    )

    input = SignalInPort.new
    output = SignalOutPort.new

    value1 = ParamInPort.new(
      :get_value_handler => ->(){ @value1 },
      :set_value_handler => ->(a){ @value1 = a},
    )

    value2 = ParamInPort.new(
      :get_value_handler => ->(){ @value2 },
      :set_value_handler => ->(a){ @value2 = a},
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
      :sample_rate_port => sample_rate_port,
      :algorithm => pass_through,
      :in_ports => { "IN" => input, "VALUE1" => value1, "VALUE2" => value2, "COMMAND" => command },
      :out_ports => { "OUT" => output }
    )
  end
end
