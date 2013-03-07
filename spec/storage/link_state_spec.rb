require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class LinkStateTestBlock < Block
  def initialize
    super(
      :arg_specs => {},
      :sample_rate => 1.0,
      :sample_rate_handler => ->(a){},
      :algorithm => ->(a){},
      :in_ports => {
        "input" => SignalInPort.new,
      },
      :out_ports => {
        "output" => SignalOutPort.new,
      }
    )
  end
end

describe SPNet::LinkState do
  describe '.new' do
    it 'should assign from and to port locaters' do
      output = PortLocater.new :block_name => "block_A", :port_name => "output"
      input = PortLocater.new :block_name => "block_B", :port_name => "input"
      link_state = LinkState.new :from => output, :to => input
      link_state.from.should eq(output)
      link_state.to.should eq(input)
    end
  end
  
  describe '#make_link' do
    it 'should make a Link object, given good blocks' do
      blocks = {
        "block_A" => LinkStateTestBlock.new,
        "block_B" => LinkStateTestBlock.new,
      }
      output = PortLocater.new :block_name => "block_A", :port_name => "output"
      input = PortLocater.new :block_name => "block_B", :port_name => "input"
      link_state = LinkState.new :from => output, :to => input
      link = link_state.make_link blocks
      link.from.should eq blocks["block_A"].out_ports["output"]
      link.to.should eq blocks["block_B"].in_ports["input"]
    end
  end
end
