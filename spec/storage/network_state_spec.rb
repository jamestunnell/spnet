require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestBlock < Block
  attr_reader :value, :command_history
  
  def initialize args = {}
    @value = 0
    @command_history = []
    
    input = SignalInPort.new
    output = SignalOutPort.new
    
    value = ValueInPort.new(
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
      :arg_specs => {},
      :sample_rate => 1.0,
      :sample_rate_handler => ->(a){},
      :algorithm => pass_through,
      :in_ports => { "IN" => input, "VALUE" => value, "COMMAND" => command },
      :out_ports => { "OUT" => output },
    )
  end
end

describe SPNet::NetworkState do
  #describe '.new' do
  #  its(:name) { should be_empty }
  #  its(:block_states) { should be_empty }
  #  its(:link_states) { should be_empty }
  #end
  
  describe '.make_network' do
    before :all do
      @network_state = NetworkState.new(
        :sample_rate => 1.0,
        :block_states => {
          "A" => BlockState.new(:class_sym => :TestBlock, :hashed_args => {}, :port_settings => { "VALUE" => 0.2}),
          "B" => BlockState.new(:class_sym => :TestBlock, :hashed_args => {}, :port_settings => { "VALUE" => 0.4})
        },
        :link_states => [
          LinkState.new(
            :from => PortLocater.new(:block_name => "A", :port_name => "OUT"),
            :to => PortLocater.new(:block_name => "B", :port_name => "IN")
          )
        ]
      )
    end

    it 'should create blocks for the given block models' do
      network = @network_state.make_network
      network.blocks.should have_key("A")
      network.blocks["A"].class.should be(TestBlock)
      network.blocks.should have_key("B")
      network.blocks["B"].class.should be(TestBlock)
    end
    
    it 'should assign values found in :port_settings' do
      network = @network_state.make_network
      network.blocks["A"].value.should eq(0.2)
      network.blocks["B"].value.should eq(0.4)
    end

    it 'should create links from :link_states' do
      network = @network_state.make_network
      network.links.count.should be 1
      network.links.first.from.should eq(network.blocks["A"].out_ports["OUT"])
      network.links.first.to.should eq(network.blocks["B"].in_ports["IN"])
    end

  end
end
