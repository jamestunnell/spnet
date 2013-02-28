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
    
    pass_through = lambda do |steps|
      output.send_values input.dequeue_values(steps)
    end
    
    super(
      :algorithm => pass_through,
      :in_ports => { "IN" => input, "VALUE" => value, "COMMAND" => command },
      :out_ports => { "OUT" => output },
    )
  end
end

describe SPNet::NetworkModel do
  describe '.new' do
    its(:name) { should be_empty }
    its(:block_models) { should be_empty }
    its(:link_models) { should be_empty }
  end
  
  describe '.make_network' do
    before :all do
      @network_model = NetworkModel.new(
        :block_models => {
          "A" => BlockModel.new(:block_class => TestBlock, :port_settings => { "VALUE" => 0.2, "COMMAND" => "SIT" }),
          "B" => BlockModel.new(:block_class => TestBlock, :port_settings => { "VALUE" => 0.4, "COMMAND" => "STAY" })
        },
        :link_models => [
          LinkModel.new(
            :from => PortLocater.new(:block_name => "A", :port_name => "OUT"),
            :to => PortLocater.new(:block_name => "B", :port_name => "IN")
          )
        ]
      )
    end

    it 'should create blocks for the given block models' do
      network = @network_model.make_network :sample_rate => 2000.0
      network.blocks.should have_key("A")
      network.blocks["A"].class.should be(TestBlock)
      network.blocks.should have_key("B")
      network.blocks["B"].class.should be(TestBlock)
    end
    
    it 'should assign values found in :port_settings' do
      network = @network_model.make_network :sample_rate => 2000.0
      network.blocks["A"].value.should eq(0.2)
      network.blocks["B"].value.should eq(0.4)
    end

    it 'should run commands found in :port_settings' do
      network = @network_model.make_network :sample_rate => 2000.0
      network.blocks["A"].command_history[0].should eq("SIT")
      network.blocks["B"].command_history[0].should eq("STAY")
    end

    it 'should create links from :link_models' do
      network = @network_model.make_network :sample_rate => 2000.0
      network.links.count.should be 1
      network.links.first.from.should eq(network.blocks["A"].out_ports["OUT"])
      network.links.first.to.should eq(network.blocks["B"].in_ports["IN"])
    end

    it 'should not activate links if not instructed to' do
      network = @network_model.make_network :sample_rate => 2000.0
      network.blocks["A"].out_ports["OUT"].link.should be_nil
      network.blocks["B"].in_ports["IN"].link.should be_nil
    end

    it 'should activate links when instructed to' do
      network = @network_model.make_network :sample_rate => 2000.0, :activate_links => true
      network.blocks["A"].out_ports["OUT"].link.should eq(network.links.first)
      network.blocks["B"].in_ports["IN"].link.should eq(network.links.first)
    end

  end
end
