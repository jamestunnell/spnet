require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::NetworkState do 
  describe '.make_network' do
    before :all do
      @network_state = NetworkState.new(
        :block_states => {
          "A" => BlockState.new(:class_sym => :TestBlock, :hashed_args => {}, :port_params => { "VALUE1" => 0.2}),
          "B" => BlockState.new(:class_sym => :TestBlock, :hashed_args => {}, :port_params => { "VALUE1" => 0.4})
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
      network = @network_state.make_network :sample_rate => 4
      network.blocks.should have_key("A")
      network.blocks["A"].class.should be(TestBlock)
      network.blocks.should have_key("B")
      network.blocks["B"].class.should be(TestBlock)
    end
    
    it 'should assign values found in :port_params' do
      network = @network_state.make_network :sample_rate => 4
      network.blocks["A"].value1.should eq(0.2)
      network.blocks["B"].value1.should eq(0.4)
    end

    it 'should create links from :link_states' do
      network = @network_state.make_network :sample_rate => 4
      network.links.count.should be 1
      network.links.first.from.should eq(network.blocks["A"].out_ports["OUT"])
      network.links.first.to.should eq(network.blocks["B"].in_ports["IN"])
    end

  end
end
